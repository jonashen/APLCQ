# APLCQ
Autonomous Precision Landing Control of Quadcopter

* **Gong Chen** - *User Interface* - In the latest commit at branch "offsetControl", I declared 2 UI components at the header file (.h file) and implemented the functionality of the UI components at the source file (.m file). 

* **Ilia Labkovsky** - *Computer Vision* - A fully standalone project is found in the computer vision folder. This includes the OpenCV framework fully integrated and running on top of the DJI Mobile SDK. CV pre-processing and Hough Circle detection is run on the iPhone camera feed with custom-tested parameters.

* **Christine Chen** - *Drone Communication* - The app that was demoed at our final presentation is the most up-to-date version of the "DC" branch, which is primarily a collaboration between Drone Communication and Flight Control.  While there is still some code from previous iterations that is currently unused, past commits may demonstrate a greater breadth of utilization of virtual stick.  All our new code is primarily in DroneControl.h/m, though it's connected via DefaultLayoutViewController
