import { Workoutkit } from 'capacitor-workoutkit';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    Workoutkit.echo({ value: inputValue })
}
