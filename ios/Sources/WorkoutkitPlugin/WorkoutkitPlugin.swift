import Foundation
import Capacitor
import WorkoutKit
import UIKit

/**
 * Capacitor plugin bridge for WorkoutKit
 *
 * Provides a bridge between JavaScript/TypeScript and the native WorkoutKit framework.
 * Supports creating planned workouts for running, cycling, and swimming.
 *
 * Requires iOS 17.0 or later.
 *
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(WorkoutkitPlugin)
public class WorkoutkitPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "WorkoutkitPlugin"
    public let jsName = "Workoutkit"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "createPlannedWorkout", returnType: CAPPluginReturnPromise)
    ]
    
    private let implementation = Workoutkit()

    /**
     * Create a planned workout using Apple's WorkoutKit framework
     *
     * @param call - Capacitor plugin call with sport and composition parameters
     * @since 0.0.1
     */
    @objc func createPlannedWorkout(_ call: CAPPluginCall) {
        // Check iOS 17+ availability
        if #unavailable(iOS 17.0) {
            call.unavailable("WorkoutKit requires iOS 17.0 or later.")
            return
        }
        
        // Parse parameters
        guard let sport = call.getString("sport") else {
            call.reject("Missing required field: sport")
            return
        }
        
        guard let composition = call.getObject("composition") else {
            call.reject("Missing required field: composition")
            return
        }
        
        // Validate sport
        guard ["running", "cycling", "swimming"].contains(sport) else {
            call.reject("Invalid sport: \(sport). Must be one of: running, cycling, swimming")
            return
        }
        
        // Create workout
        implementation.createPlannedWorkout(sport: sport, composition: composition) { result in
            switch result {
            case .success:
                call.resolve(["success": true])
            case .failure(let error):
                call.resolve(["success": false, "error": error.localizedDescription])
            }
        }
    }
}
