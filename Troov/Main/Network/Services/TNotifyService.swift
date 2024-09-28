//
//  TNotifyService.swift
//  Troov
//
//  Created by Levon Arakelyan on 13.08.23.
//

import Foundation

protocol TNotifyServiceable {
    func notify() async -> Result<[Notification], TRequestError>
}

class TNotifyService: THTTPClient, THTTPLocalClient, TNotifyServiceable {
    func notify() async -> Result<[Notification], TRequestError> {
        return await sendRequest(endpoint: TNotifyEndpoint.notify, responseModel: [Notification].self)
    }

    func reset() { resetSession() }
    /**
     Max retries
     */
    private let maxRetryCount: Int = 3
    /**
     After 10 seconds
     */
    private let retryPeriod: TimeInterval = 10
    
    private var task: Task<(), Never>?
    /**
     Retry counters
     */
    private var notifyRetryCounter: Int = 0

    deinit {
        cancelTask()
    }
}

/**
long poll
 */
extension TNotifyService {
    /**
     1. Time out 16 minutes,
     2. If the server is down, kill the task. (retry 3 times)
     3. Anything is not a timeout is a server failure -
     4. Some logic to try again maybe?
     */
    func notify(completion: @escaping ([Notification]) -> ()) {
       
       guard TAuth0.shared.hasValid else { return }

       task?.cancel()
       task = Task.detached(priority: .background) { [weak self] in
            guard let self = self else { return }
            guard TAuth0.shared.hasValid else { return }
            let result = await self.notify()
            guard !Task.isCancelled else { return }
            switch result {
            case .success(let sessions):
                self.notifyRetryCounter = 0
                completion(sessions)
            case .failure(let error):
                if !error.isTimeout {
                    self.notifyRetryCounter += 1
                }
            }
            self.cancelTask()
            guard self.notifyRetryCounter < self.maxRetryCount else {
                self.runSessionRetryAfterDelay(completion: completion)
                return
            }
            self.notify(completion: completion)
        }
    }
    
    private func cancelTask() {
        if task != nil {
            task?.cancel()
            task = nil
        }
    }
    
    private func runSessionRetryAfterDelay(completion: @escaping ([Notification]) -> ()) {
        DispatchQueue.global(qos: .background)
            .asyncAfter(deadline: .now() + retryPeriod,
                        execute: { [weak self] in
            guard let self = self else { return }
            self.resetSession()
            self.notify(completion: completion)
        })
    }

    private func resetSession() {
        cancelTask()
        notifyRetryCounter = 0
    }
}
