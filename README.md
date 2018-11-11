 <p align="center">
    <img src="https://github.com/panosx2/brightness/blob/master/icons/128/com.github.panosx2.brightness.png" alt="logo"> <br>
 </p>

 <div>
  <h1 align="center">Dimmer</h1>
  <h3 align="center"><i>Brightness Adjustment App, written in Vala</i></h3>
</div>

<p align="center">
    <img src="https://github.com/panosx2/brightness/blob/master/data/screenshot.png" alt="Screenshot"> <br>
</p>

 Instead of adjusting the backlight, this app uses `xrandr` to change the brightness of the image displayed on your screen. This can be useful for displays without an adjustable backlight, displays with a too-bright minimum backlight, or OLED displays.

 ## Install from AppCenter 
 On elementaryOS simply install Dimmer from AppCenter:
 <p align="center">
   <a href="https://appcenter.elementary.io/com.github.panosx2.brightness">
     <img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter">
   </a>
 </p>

 ### or

 ## Build and Install manually
 
 These dependencies must be present before building:

 * debhelper
 * gettext
 * libgranite-dev
 * libgtk-3-dev
 * meson
 * valac
 
 <p>You can install these by executing the command:</p>
 
 `sudo apt install meson valac libgranite-dev libgtk-3-dev gettext debhelper`
 
 <br>
 <b>Building</b>
 
`meson build && cd build`

`meson configure -Dprefix=/usr`
 
`ninja`

<br>
<b>Installing</b>

`sudo ninja install`

 ## Credits
 <div>Icons made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> (Licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY)</a></div>
