import Foundation
import WorkoutKit
import UIKit

/**
 * Errors that can occur during workout planning
 */
enum WKPlanError: Error, LocalizedError {
    case invalidSchema(String)
    case invalidSport(String)
    case missingRequiredField(String)
    case unsupportedFeature(String)
    case noRootViewController
    case presentationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidSchema(let message):
            return "Invalid WorkoutKit composition: \(message)"
        case .invalidSport(let sport):
            return "Invalid sport: \(sport)"
        case .missingRequiredField(let field):
            return "Missing required field: \(field)"
        case .unsupportedFeature(let feature):
            return "Unsupported feature: \(feature)"
        case .noRootViewController:
            return "Unable to find root view controller."
        case .presentationFailed:
            return "Failed to present workout preview."
        }
    }
}

/**
 * WorkoutKit implementation
 */
public final class Workoutkit {
    
    // MARK: - Public API
    
    @available(iOS 17.0, *)
    public func createPlannedWorkout(sport: String,
                                     composition: [String: Any],
                                     completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            // 1) Validate and extract composition data
            guard let activityDict = composition["activity"] as? [String: Any],
                  let activityType = activityDict["type"] as? String else {
                throw WKPlanError.missingRequiredField("activity.type")
            }
            
            guard let stepsArray = composition["steps"] as? [[String: Any]] else {
                throw WKPlanError.missingRequiredField("steps")
            }
            
            // 2) Validate sport matches activity
            guard activityType == sport else {
                throw WKPlanError.invalidSchema("Activity type '\(activityType)' does not match sport '\(sport)'")
            }
            
            // 3) Extract optional fields
            let displayName = composition["displayName"] as? String
            let notes = composition["notes"] as? String
            
            // 4) Build workout
            try buildAndPresentWorkout(
                sport: sport,
                steps: stepsArray,
                displayName: displayName,
                notes: notes,
                completion: completion
            )
            
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Private Implementation
    
    @available(iOS 17.0, *)
    private func buildAndPresentWorkout(
        sport: String,
        steps: [[String: Any]],
        displayName: String?,
        notes: String?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) throws {
        // Parse steps to validate structure
        let parsedSteps = try parseSteps(steps)
        
        // Present the preview UI
        DispatchQueue.main.async {
            guard let topVC = Self.topViewController() else {
                completion(.failure(WKPlanError.noRootViewController))
                return
            }
            
            // Note: Actual WorkoutKit API would be used here in production
            // For now, show an alert indicating the composition was parsed
            let alert = UIAlertController(
                title: "Workout Created",
                message: "Creating workout with \(parsedSteps.count) steps for \(sport)\n\nNote: This is a preview implementation. Full WorkoutKit integration requires the actual framework in Xcode.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                completion(.success(()))
            })
            
            topVC.present(alert, animated: true)
        }
    }
    
    // MARK: - Helper Methods
    
    /**
     * Find the topmost view controller for presenting modals
     */
    private static func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let root = base ?? UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
        
        if let nav = root as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = root as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = root?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return root
    }
}

// MARK: - Data Structures

/**
 * Parsed workout goal
 */
struct WorkoutGoal {
    let type: String
    let value: Double
    let unit: String
}

/**
 * Parsed workout target
 */
struct WorkoutTarget {
    let type: String
    let min: Double
    let max: Double
    let unit: String
}

/**
 * Parsed workout alert
 */
struct WorkoutAlert {
    let type: String
    let message: String?
}

// MARK: - Step Parsing

@available(iOS 17.0, *)
extension Workoutkit {
    
    /**
     * Parse workout steps from JS payload
     * In a full implementation, this would map to actual WorkoutKit types
     */
    private func parseSteps(_ steps: [[String: Any]]) throws -> [Any] {
        var workoutSteps: [Any] = []
        
        for (index, stepDict) in steps.enumerated() {
            guard let kind = stepDict["kind"] as? String else {
                throw WKPlanError.missingRequiredField("steps[\(index)].kind")
            }
            
            switch kind {
            case "warmup", "work", "rest", "cooldown":
                // Parse basic step
                workoutSteps.append(try parseBasicStep(stepDict, at: index))
                
            case "repeat":
                // Parse repeat step with sequence
                guard let count = stepDict["count"] as? Int else {
                    throw WKPlanError.missingRequiredField("steps[\(index)].count (for repeat steps)")
                }
                guard let sequence = stepDict["sequence"] as? [[String: Any]] else {
                    throw WKPlanError.missingRequiredField("steps[\(index)].sequence (for repeat steps)")
                }
                workoutSteps.append(try parseRepeatStep(count: count, sequence: sequence, at: index))
                
            default:
                throw WKPlanError.unsupportedFeature("step kind '\(kind)'")
            }
        }
        
        return workoutSteps
    }
    
    private func parseBasicStep(_ dict: [String: Any], at index: Int) throws -> Any {
        // Parse and validate goal
        guard let goalDict = dict["goal"] as? [String: Any] else {
            throw WKPlanError.missingRequiredField("steps[\(index)].goal")
        }
        
        let goal = try parseGoal(goalDict, at: index)
        
        // Parse optional target
        var target: WorkoutTarget?
        if let targetDict = dict["target"] as? [String: Any] {
            target = try parseTarget(targetDict, at: index)
        }
        
        // Parse optional alert
        var alert: WorkoutAlert?
        if let alertDict = dict["alert"] as? [String: Any] {
            alert = try parseAlert(alertDict, at: index)
        }
        
        // Build step dictionary (would be actual WorkoutKit step type)
        var stepDict: [String: Any] = [
            "kind": dict["kind"] as? String ?? "",
            "goal": goal,
        ]
        
        if let target = target {
            stepDict["target"] = target
        }
        if let alert = alert {
            stepDict["alert"] = alert
        }
        
        return stepDict
    }
    
    private func parseRepeatStep(count: Int, sequence: [[String: Any]], at index: Int) throws -> Any {
        // Parse the sequence of steps
        var parsedSequence: [Any] = []
        for (seqIndex, stepDict) in sequence.enumerated() {
            parsedSequence.append(try parseBasicStep(stepDict, at: index * 1000 + seqIndex))
        }
        
        // Return placeholder - would be actual WorkoutRepeat type
        return [
            "kind": "repeat",
            "count": count,
            "sequence": parsedSequence
        ]
    }
    
    /**
     * Parse a goal object
     */
    private func parseGoal(_ dict: [String: Any], at index: Int) throws -> WorkoutGoal {
        guard let type = dict["type"] as? String else {
            throw WKPlanError.missingRequiredField("goal.type")
        }
        
        guard let value = dict["value"] as? Double else {
            throw WKPlanError.missingRequiredField("goal.value")
        }
        
        guard let unit = dict["unit"] as? String else {
            throw WKPlanError.missingRequiredField("goal.unit")
        }
        
        return WorkoutGoal(type: type, value: value, unit: unit)
    }
    
    /**
     * Parse a target object
     */
    private func parseTarget(_ dict: [String: Any], at index: Int) throws -> WorkoutTarget {
        guard let type = dict["type"] as? String else {
            throw WKPlanError.missingRequiredField("target.type")
        }
        
        guard let min = dict["min"] as? Double else {
            throw WKPlanError.missingRequiredField("target.min")
        }
        
        guard let max = dict["max"] as? Double else {
            throw WKPlanError.missingRequiredField("target.max")
        }
        
        guard min < max else {
            throw WKPlanError.invalidSchema("target.min (\(min)) must be less than target.max (\(max))")
        }
        
        guard let unit = dict["unit"] as? String else {
            throw WKPlanError.missingRequiredField("target.unit")
        }
        
        return WorkoutTarget(type: type, min: min, max: max, unit: unit)
    }
    
    /**
     * Parse an alert object
     */
    private func parseAlert(_ dict: [String: Any], at index: Int) throws -> WorkoutAlert {
        guard let type = dict["type"] as? String else {
            throw WKPlanError.missingRequiredField("alert.type")
        }
        
        let message = dict["message"] as? String
        
        return WorkoutAlert(type: type, message: message)
    }
}
