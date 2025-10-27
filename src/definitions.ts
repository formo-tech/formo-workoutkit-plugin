/**
 * WorkoutKit Plugin for Capacitor
 *
 * Provides integration with Apple's WorkoutKit framework to create planned workouts.
 * Requires iOS 17.0 or later.
 *
 * @since 0.0.1
 */

/**
 * Supported workout sports
 * @since 0.0.1
 */
export type WorkoutSport = 'running' | 'cycling' | 'swimming';

/**
 * Workout step types
 * @since 0.0.1
 */
export type WorkoutStepKind = 'warmup' | 'work' | 'rest' | 'cooldown' | 'repeat';

/**
 * Goal types for workout steps
 * @since 0.0.1
 */
export type WorkoutGoalType = 'time' | 'distance' | 'pace' | 'power' | 'heartRate';

/**
 * Activity location for workout
 * @since 0.0.1
 */
export type WorkoutLocation = 'indoor' | 'outdoor';

/**
 * Duration unit
 * @since 0.0.1
 */
export type WorkoutDurationUnit = 'seconds' | 'minutes' | 'hours';

/**
 * Distance unit
 * @since 0.0.1
 */
export type WorkoutDistanceUnit = 'meters' | 'kilometers' | 'miles';

/**
 * Pace unit
 * @since 0.0.1
 */
export type WorkoutPaceUnit = 'secondsPerKilometer' | 'secondsPerMile' | 'minutesPerKilometer' | 'minutesPerMile';

/**
 * Power unit
 * @since 0.0.1
 */
export type WorkoutPowerUnit = 'watts';

/**
 * Heart rate unit
 * @since 0.0.1
 */
export type WorkoutHeartRateUnit = 'bpm';

/**
 * Goal for a workout step
 * @since 0.0.1
 */
export interface WorkoutGoal {
  /** Type of goal */
  type: WorkoutGoalType;
  /** Goal value */
  value: number;
  /** Unit for the goal value */
  unit: WorkoutDurationUnit | WorkoutDistanceUnit | WorkoutPaceUnit | WorkoutPowerUnit | WorkoutHeartRateUnit;
}

/**
 * Target zone for a workout step
 * @since 0.0.1
 */
export interface WorkoutTarget {
  /** Type of target */
  type: 'pace' | 'power' | 'heartRate';
  /** Minimum value in zone */
  min: number;
  /** Maximum value in zone */
  max: number;
  /** Unit for the target values */
  unit: WorkoutPaceUnit | WorkoutPowerUnit | WorkoutHeartRateUnit;
}

/**
 * Alert or cue for a workout step (optional)
 * @since 0.0.1
 */
export interface WorkoutAlert {
  /** Type of alert */
  type: 'speech' | 'haptic' | 'sound' | 'visual';
  /** Alert message (for speech) */
  message?: string;
}

/**
 * Base workout step
 * @since 0.0.1
 */
export interface WorkoutStep {
  /** Step kind */
  kind: Exclude<WorkoutStepKind, 'repeat'>;
  /** Goal for this step */
  goal: WorkoutGoal;
  /** Optional target zone */
  target?: WorkoutTarget;
  /** Optional alert */
  alert?: WorkoutAlert;
}

/**
 * Repeat step that contains a sequence of steps
 * @since 0.0.1
 */
export interface WorkoutRepeatStep {
  /** Must be 'repeat' */
  kind: 'repeat';
  /** Number of times to repeat the sequence */
  count: number;
  /** Sequence of steps to repeat */
  sequence: WorkoutStep[];
}

/**
 * Activity configuration for the workout
 * @since 0.0.1
 */
export interface WorkoutActivity {
  /** Activity type (must match sport) */
  type: WorkoutSport;
  /** Activity location */
  location?: WorkoutLocation;
}

/**
 * Complete workout composition
 * @since 0.0.1
 */
export interface WorkoutComposition {
  /** Activity configuration */
  activity: WorkoutActivity;
  /** Array of workout steps */
  steps: (WorkoutStep | WorkoutRepeatStep)[];
  /** Optional display name for the workout */
  displayName?: string;
  /** Optional notes about the workout */
  notes?: string;
}

/**
 * Options for creating a planned workout
 * @since 0.0.1
 */
export interface CreatePlannedWorkoutOptions {
  /** Sport type for the workout */
  sport: WorkoutSport;
  /** Workout composition with steps and goals */
  composition: WorkoutComposition;
}

/**
 * Result from creating a planned workout
 * @since 0.0.1
 */
export interface CreatePlannedWorkoutResult {
  /** Whether the workout was created successfully */
  success: boolean;
  /** Error message if creation failed */
  error?: string;
}

/**
 * Main WorkoutKit plugin interface
 * @since 0.0.1
 */
export interface WorkoutkitPlugin {
  /**
   * Create a planned workout using Apple's WorkoutKit framework
   *
   * @param options - Workout configuration including sport and composition
   * @returns Promise resolving to success/error result
   * @throws If platform is unavailable (not iOS 17+)
   *
   * @since 0.0.1
   */
  createPlannedWorkout(options: CreatePlannedWorkoutOptions): Promise<CreatePlannedWorkoutResult>;
}
