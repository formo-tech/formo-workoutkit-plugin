# @formo/capacitor-workoutkit

Capacitor plugin for creating planned workouts using Apple WorkoutKit

## Install

```bash
npm install @formo/capacitor-workoutkit
npx cap sync
```

> **Important:** This plugin requires iOS 17.0 or later. WorkoutKit is not available on Android or web platforms.

## Usage

Import the Workoutkit plugin in your TypeScript code:

```typescript
import { Workoutkit } from '@formo/capacitor-workoutkit';
```

### Basic Example: Time-based Workout

```typescript
const result = await Workoutkit.createPlannedWorkout({
  sport: 'running',
  composition: {
    activity: {
      type: 'running',
      location: 'outdoor',
    },
    displayName: 'Quick Morning Run',
    notes: 'Easy 20-minute jog',
    steps: [
      {
        kind: 'warmup',
        goal: { type: 'time', value: 300, unit: 'seconds' },
      },
      {
        kind: 'work',
        goal: { type: 'time', value: 1200, unit: 'seconds' },
      },
      {
        kind: 'cooldown',
        goal: { type: 'time', value: 300, unit: 'seconds' },
      },
    ],
  },
});

if (result.success) {
  console.log('Workout preview presented successfully');
} else {
  console.error('Failed:', result.error);
}
```

### Advanced Example: Interval Training with Target Zones

```typescript
const result = await Workoutkit.createPlannedWorkout({
  sport: 'running',
  composition: {
    activity: {
      type: 'running',
      location: 'outdoor',
    },
    displayName: '30min Interval Run',
    notes: 'Easy warmup, 5x3min intervals, cooldown',
    steps: [
      {
        kind: 'warmup',
        goal: { type: 'time', value: 600, unit: 'seconds' },
      },
      {
        kind: 'repeat',
        count: 5,
        sequence: [
          {
            kind: 'work',
            goal: { type: 'time', value: 180, unit: 'seconds' },
            target: {
              type: 'pace',
              min: 240,
              max: 270,
              unit: 'secondsPerKilometer',
            },
          },
          {
            kind: 'rest',
            goal: { type: 'time', value: 120, unit: 'seconds' },
          },
        ],
      },
      {
        kind: 'cooldown',
        goal: { type: 'time', value: 300, unit: 'seconds' },
      },
    ],
  },
});
```

### Cycling Workout Example

```typescript
const result = await Workoutkit.createPlannedWorkout({
  sport: 'cycling',
  composition: {
    activity: {
      type: 'cycling',
      location: 'indoor',
    },
    displayName: 'Indoor Cycling Session',
    steps: [
      {
        kind: 'warmup',
        goal: { type: 'time', value: 600, unit: 'seconds' },
      },
      {
        kind: 'repeat',
        count: 3,
        sequence: [
          {
            kind: 'work',
            goal: { type: 'time', value: 300, unit: 'seconds' },
            target: {
              type: 'power',
              min: 180,
              max: 220,
              unit: 'watts',
            },
          },
          {
            kind: 'rest',
            goal: { type: 'time', value: 120, unit: 'seconds' },
          },
        ],
      },
      {
        kind: 'cooldown',
        goal: { type: 'time', value: 600, unit: 'seconds' },
      },
    ],
  },
});
```

### Swimming Workout Example

```typescript
const result = await Workoutkit.createPlannedWorkout({
  sport: 'swimming',
  composition: {
    activity: {
      type: 'swimming',
      location: 'indoor',
    },
    displayName: 'Distance Swim',
    notes: '400m swim workout',
    steps: [
      {
        kind: 'warmup',
        goal: { type: 'distance', value: 200, unit: 'meters' },
      },
      {
        kind: 'work',
        goal: { type: 'distance', value: 400, unit: 'meters' },
      },
      {
        kind: 'cooldown',
        goal: { type: 'distance', value: 200, unit: 'meters' },
      },
    ],
  },
});
```

## API Reference

### createPlannedWorkout(options)

Create a planned workout using Apple's WorkoutKit framework.

**Parameters:**

| Param         | Type                                                                                | Description           |
| ------------- | ----------------------------------------------------------------------------------- | --------------------- |
| **`options`** | <code><a href="#createplannedworkoutoptions">CreatePlannedWorkoutOptions</a></code> | Workout configuration |

**Returns:** <code>Promise&lt;<a href="#createplannedworkoutresult">CreatePlannedWorkoutResult</a>&gt;</code>

**Since:** 0.0.1

**Platforms:** iOS

---

### Interfaces

#### CreatePlannedWorkoutOptions

| Prop              | Type                                                              | Description                              |
| ----------------- | ----------------------------------------------------------------- | ---------------------------------------- |
| **`sport`**       | <code><a href="#workoutsport">WorkoutSport</a></code>             | Sport type for the workout               |
| **`composition`** | <code><a href="#workoutcomposition">WorkoutComposition</a></code> | Workout composition with steps and goals |

#### CreatePlannedWorkoutResult

| Prop          | Type                 | Description                                  |
| ------------- | -------------------- | -------------------------------------------- |
| **`success`** | <code>boolean</code> | Whether the workout was created successfully |
| **`error`**   | <code>string</code>  | Error message if creation failed             |

#### WorkoutComposition

| Prop              | Type                                                                                                          | Description                           |
| ----------------- | ------------------------------------------------------------------------------------------------------------- | ------------------------------------- |
| **`activity`**    | <code><a href="#workoutactivity">WorkoutActivity</a></code>                                                   | Activity configuration                |
| **`steps`**       | <code>(<a href="#workoutstep">WorkoutStep</a> \| <a href="#workoutrepeatstep">WorkoutRepeatStep</a>)[]</code> | Array of workout steps                |
| **`displayName`** | <code>string</code>                                                                                           | Optional display name for the workout |
| **`notes`**       | <code>string</code>                                                                                           | Optional notes about the workout      |

#### WorkoutActivity

| Prop           | Type                                                        | Description                      |
| -------------- | ----------------------------------------------------------- | -------------------------------- |
| **`type`**     | <code><a href="#workoutsport">WorkoutSport</a></code>       | Activity type (must match sport) |
| **`location`** | <code><a href="#workoutlocation">WorkoutLocation</a></code> | Activity location                |

#### WorkoutStep

| Prop         | Type                                                    | Description          |
| ------------ | ------------------------------------------------------- | -------------------- |
| **`kind`**   | <code>'warmup' \| 'work' \| 'rest' \| 'cooldown'</code> | Step kind            |
| **`goal`**   | <code><a href="#workoutgoal">WorkoutGoal</a></code>     | Goal for this step   |
| **`target`** | <code><a href="#workouttarget">WorkoutTarget</a></code> | Optional target zone |
| **`alert`**  | <code><a href="#workoutalert">WorkoutAlert</a></code>   | Optional alert       |

#### WorkoutRepeatStep

| Prop           | Type                                                  | Description                            |
| -------------- | ----------------------------------------------------- | -------------------------------------- |
| **`kind`**     | <code>'repeat'</code>                                 | Must be 'repeat'                       |
| **`count`**    | <code>number</code>                                   | Number of times to repeat the sequence |
| **`sequence`** | <code><a href="#workoutstep">WorkoutStep</a>[]</code> | Sequence of steps to repeat            |

#### WorkoutGoal

| Prop        | Type                                                        | Description             |
| ----------- | ----------------------------------------------------------- | ----------------------- |
| **`type`**  | <code><a href="#workoutgoaltype">WorkoutGoalType</a></code> | Type of goal            |
| **`value`** | <code>number</code>                                         | Goal value              |
| **`unit`**  | <code><a href="#workoutunit">WorkoutUnit</a></code>         | Unit for the goal value |

#### WorkoutTarget

| Prop       | Type                                                | Description                |
| ---------- | --------------------------------------------------- | -------------------------- |
| **`type`** | <code>'pace' \| 'power' \| 'heartRate'</code>       | Type of target             |
| **`min`**  | <code>number</code>                                 | Minimum value in zone      |
| **`max`**  | <code>number</code>                                 | Maximum value in zone      |
| **`unit`** | <code><a href="#workoutunit">WorkoutUnit</a></code> | Unit for the target values |

#### WorkoutAlert

| Prop          | Type                                                     | Description                |
| ------------- | -------------------------------------------------------- | -------------------------- |
| **`type`**    | <code>'speech' \| 'haptic' \| 'sound' \| 'visual'</code> | Type of alert              |
| **`message`** | <code>string</code>                                      | Alert message (for speech) |

### Type Aliases

#### WorkoutSport

<code>'running' \| 'cycling' \| 'swimming'</code>

#### WorkoutStepKind

<code>'warmup' \| 'work' \| 'rest' \| 'cooldown' \| 'repeat'</code>

#### WorkoutGoalType

<code>'time' \| 'distance' \| 'pace' \| 'power' \| 'heartRate'</code>

#### WorkoutLocation

<code>'indoor' \| 'outdoor'</code>

#### WorkoutUnit

Various unit types for durations, distances, paces, power, and heart rate.

## Platform Support

| Platform | Supported | Notes                      |
| -------- | --------- | -------------------------- |
| iOS      | ✅        | Requires iOS 17.0 or later |
| Android  | ❌        | Not supported              |
| Web      | ❌        | Not supported              |

## Error Handling

The `createPlannedWorkout` method returns a result object with a `success` boolean and optional `error` message:

```typescript
const result = await Workoutkit.createPlannedWorkout(options);

if (result.success) {
  // Workout preview presented successfully
} else {
  // Handle error
  console.error('Error:', result.error);
}
```

Common errors:

- `"WorkoutKit requires iOS 17.0 or later"` - Platform version too old
- `"Missing required field: sport"` - Required parameter missing
- `"Invalid sport: ..."` - Unsupported sport type
- `"Missing required field: composition"` - Composition not provided
- Various schema validation errors for malformed workout data

## Schema Reference

### Step Kinds

- **warmup**: Warm-up phase before main workout
- **work**: Active work interval
- **rest**: Rest period
- **cooldown**: Cool-down phase after workout
- **repeat**: Repeats a sequence of steps multiple times

### Goal Types

- **time**: Time-based goal (e.g., run for 30 minutes)
- **distance**: Distance-based goal (e.g., run 5 kilometers)
- **pace**: Pace target (e.g., maintain 5 min/km)
- **power**: Power target (e.g., maintain 200W) - cycling only
- **heartRate**: Heart rate target (e.g., stay in zone 2)

### Units

#### Duration Units

- `seconds` - Duration in seconds
- `minutes` - Duration in minutes
- `hours` - Duration in hours

#### Distance Units

- `meters` - Distance in meters
- `kilometers` - Distance in kilometers
- `miles` - Distance in miles

#### Pace Units

- `secondsPerKilometer` - Seconds per kilometer
- `secondsPerMile` - Seconds per mile
- `minutesPerKilometer` - Minutes per kilometer
- `minutesPerMile` - Minutes per mile

#### Power Units

- `watts` - Power in watts (cycling)

#### Heart Rate Units

- `bpm` - Beats per minute

### Validation Rules

1. **Sport validation**: Must be 'running', 'cycling', or 'swimming'
2. **Activity type**: Must match the sport parameter
3. **Steps array**: Must contain at least one step
4. **Repeat steps**: Must have `count` >= 1 and non-empty `sequence`
5. **Goals**: Must have valid type, value, and unit
6. **Targets**: Min value must be less than max value

## Examples by Sport

### Running Workouts

Time-based:

```typescript
goal: { type: 'time', value: 30, unit: 'minutes' }
```

Distance-based:

```typescript
goal: { type: 'distance', value: 5, unit: 'kilometers' }
```

Pace target:

```typescript
target: { type: 'pace', min: 240, max: 270, unit: 'secondsPerKilometer' }
```

### Cycling Workouts

Time-based:

```typescript
goal: { type: 'time', value: 45, unit: 'minutes' }
```

Power target:

```typescript
target: { type: 'power', min: 180, max: 220, unit: 'watts' }
```

### Swimming Workouts

Distance-based:

```typescript
goal: { type: 'distance', value: 800, unit: 'meters' }
```

## Contributing

Contributions are welcome! Please read our contributing guide first.

## License

MIT
