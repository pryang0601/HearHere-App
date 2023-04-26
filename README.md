# HearHere-App
## Hearing Assistance System-- HearHere
### Problem Description
<p> When walking on the street, normal people can prevent dangerous situation by hearing environmental sound. In contrast, a deaf person may put themselves into danger because they cannot hear the surrounding sounds.</p>

### Proposed Solution
<p> Develop a system and classify the sound, then show the result in the application that people can be aware of the environmental sound in time.</p>

### Methods
<ul>
  <li> System: The system is based on Raspberry Pi and ReSpeaker 6-mic Circular array kit. In ReSpeaker, there are 6 microphone which can record the sound.The Raspberry Pi is charged with a portable charger</li>
  <li> Classification: The classification method use TensorFlow Yamnet model to get the top 5 highest accuracy sounds</li>
  <li> Application: The application uses <i>Swift</i> to build the interface.</li>
</ul>

### Notes of Application
<ol> 
  <li> Information block: In the upper-right part of the interface, there is a information button. Users can click the buttom to learn how to see the result clearly. </li>
  <li> Color: The sound in this system is distinguished based on their extent of danger. 
    <ul> 
      <li> Green: the extent of danger = 0 </li>
      <li> Yellow: the extent of danger = 1 </li>
      <li> Orange: the extent of danger = 2 </li>
      <li> Red: the extent of danger = 3 </li>
    </ul>
  </li>
  <li> Direction: In the upper part of the interface, there is an arrow, indicating the direction of a sound. </li>
  <li> Vibration: If there is the sound that the extent of danger is in the range 1~3, then the phone will vibrate. In this case, users don't need to keep watching the screen as they are walking.</li>
  </ul>
