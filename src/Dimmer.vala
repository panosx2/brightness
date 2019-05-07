/*
* Copyright (c) 2018-2019 Panos P. (https://github.com/panosx2/brightness)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Panos P. <panosp.dev@gmail.com>
*/

using Gtk;
using Gee;

public class Dimmer :  Gtk.Application {
    public static Gtk.Scale slider;
    public static Gtk.Scale slider1;
    public static Gtk.Scale slider2;
    public static Gtk.Scale slider3;
    public static Gtk.Scale slider4;
    
    public static Label label1;
    public static Label label2; 
    public static Label label3; 
    public static Label label4;
    
    public static Switch switcher;
    
    public static ArrayList<string> lines;
    public static string[] monitors;
    
     public Dimmer () {
        Object (
            application_id: "com.github.panosx2.brightness", 
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        Window window = new Gtk.ApplicationWindow(this);
        window.title = "Dimmer";
        window.window_position = WindowPosition.CENTER;
        window.set_decorated(true);
        window.set_deletable(true);
        window.set_resizable(false);
        window.destroy.connect(Gtk.main_quit);
        window.border_width = 20;
        
        var vboxMain = new Box (Orientation.VERTICAL, 0);
        vboxMain.homogeneous = false;
        
        var vboxInd = new Box (Orientation.VERTICAL, 0);
        vboxInd.homogeneous = false;

        string currentBr, /*currentGm,*/ names;

        try {
                GLib.Process.spawn_command_line_sync("sh -c \"xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '\"", out currentBr);
        } catch (SpawnError se) { currentBr = "100"; }

        /*
        try {
                GLib.Process.spawn_command_line_sync("sh -c \"xrandr --verbose | grep -m 1 -i gamma | cut -f2 -d ' '\"", out currentGm);
        } catch (SpawnError se) { currentGm = "1.0:1.0:1.0"; }
        */

        try {
                GLib.Process.spawn_command_line_sync("sh -c \"xrandr | grep ' connected ' | awk '{ print$1 }'\"", out names);
        } catch (SpawnError se) { names = ""; }

        string[] tempLines = names.split("\n");
       
        lines = new ArrayList<string>();
        
        for (int i = 0; i < tempLines.length; i++) if (tempLines[i] != "") lines.add(tempLines[i]);
        
        //this is my main slider
        slider = new Scale.with_range(Orientation.HORIZONTAL, 40, 150, 1);
        slider.set_size_request(380, 50);
        
        if (lines.size > 1) {
            var hboxAll = new Box (Orientation.HORIZONTAL, 0);
            hboxAll.homogeneous = false;
        
            var label = new Label("All Monitors:");
            label.halign = Align.START;
            label.set_margin_bottom(30);
            
            switcher = new Switch();
            switcher.active = true;
            switcher.state_changed.connect(() => {
                if (switcher.active == true) {
                    slider.visible = true; 
                    vboxInd.visible = false;
                    
                    //initialization
                    setValueForAll();
                }
                else {
                    slider.visible = false;
                    vboxInd.visible = true;
                    
                    //initialization
                    setValuesForEveryMonitor();
                }
            });
            switcher.set_margin_bottom(30);
            
            hboxAll.pack_start(label, false, false, 0);
            hboxAll.pack_end(switcher, false, false, 0);
            
            vboxMain.add(hboxAll);
        }
        else { //if only one exists
            //initialization
            setValueForAll();
        }
        
        monitors = {"", "", "", ""};
        
        for (int i = 0; i < lines.size; i++) monitors[i] = lines.get(i);
        
        if (lines.size > 1) {
            //slider1
            label1 = new Label(monitors[0]);
            label1.halign = Align.START;
            
            slider1 = new Scale.with_range(Orientation.HORIZONTAL, 40, 150, 1);
            slider1.set_size_request(380, 30);
            slider1.adjustment.value_changed.connect (() => {
                try {
                        string edited = (slider1.adjustment.value / 100).to_string();

                        //if ((slider1.adjustment.value / 100) >= 1.0) {
                            //GLib.Process.spawn_command_line_async("xrandr --output " + monitors[0] + " --gamma " + edited + ":" + edited + ":" + edited);
                        //}
                        //else 
                        GLib.Process.spawn_command_line_async("xrandr --output " + monitors[0] + " --brightness " + edited);
                        
                        saveValue(".dimmer_" + monitors[0] + ".txt", edited);

                        if ((slider1.adjustment.value / 100) > 1.2) slider1.tooltip_text = "Too Bright";
                        else if ((slider1.adjustment.value / 100) < 0.6) slider1.tooltip_text = "Too Dark";
                        else slider1.tooltip_text = "";
                } catch (SpawnError se) {}
            });
            slider1.set_margin_bottom(30);
            
            //slider2
            label2 = new Label(monitors[1]);
            label2.halign = Align.START;
            
            slider2 = new Scale.with_range(Orientation.HORIZONTAL, 40, 150, 1);
            slider2.set_size_request(380, 30);
            slider2.adjustment.value_changed.connect (() => {
                try {
                        string edited = (slider2.adjustment.value / 100).to_string();

                       GLib.Process.spawn_command_line_async("xrandr --output " + monitors[1] + " --brightness " + edited);
                       
                       saveValue(".dimmer_" + monitors[1] + ".txt", edited);

                        if ((slider2.adjustment.value / 100) > 1.2) slider2.tooltip_text = "Too Bright";
                        else if ((slider2.adjustment.value / 100) < 0.6) slider2.tooltip_text = "Too Dark";
                        else slider2.tooltip_text = "";
                } catch (SpawnError se) {}
            });
            slider2.set_margin_bottom(30);
            
            //slider3
            label3 = new Label(monitors[2]);
            label3.halign = Align.START;
            
            slider3 = new Scale.with_range(Orientation.HORIZONTAL, 40, 150, 1);
            slider3.set_size_request(380, 30);
            slider3.adjustment.value_changed.connect (() => {
                try {
                        string edited = (slider3.adjustment.value / 100).to_string();

                        GLib.Process.spawn_command_line_async("xrandr --output " + monitors[2] + " --brightness " + edited);
                        
                        saveValue(".dimmer_" + monitors[2] + ".txt", edited);

                        if ((slider3.adjustment.value / 100) > 1.2) slider3.tooltip_text = "Too Bright";
                        else if ((slider3.adjustment.value / 100) < 0.6) slider3.tooltip_text = "Too Dark";
                        else slider3.tooltip_text = "";
                } catch (SpawnError se) {}
            });
            slider3.set_margin_bottom(30);
            
            //slider4
            label4 = new Label(monitors[3]);
            label4.halign = Align.START;
            
            slider4 = new Scale.with_range(Orientation.HORIZONTAL, 40, 150, 1);
            slider4.set_size_request(380, 30);
            slider4.adjustment.value_changed.connect (() => {
                try {
                        string edited = (slider4.adjustment.value / 100).to_string();

                        GLib.Process.spawn_command_line_async("xrandr --output " + monitors[3] + " --brightness " + edited);
                        
                       saveValue(".dimmer_" + monitors[3] + ".txt", edited);

                        if ((slider4.adjustment.value / 100) > 1.2) slider4.tooltip_text = "Too Bright";
                        else if ((slider4.adjustment.value / 100) < 0.6) slider4.tooltip_text = "Too Dark";
                        else slider4.tooltip_text = "";
                } catch (SpawnError se) {}
            });
            
            //set the values at start (when more than 1 exists)
            setValuesForEveryMonitor();
        
            if (slider1.get_value() != slider2.get_value()) {
                switcher.set_active(false);
            }
        }
            
        //action for main slider
        slider.adjustment.value_changed.connect (() => {  
            try {
                    string edited = (slider.adjustment.value / 100).to_string();

                    for (int i = 0; i < lines.size; i++) GLib.Process.spawn_command_line_async("xrandr --output " + lines.get(i) + " --brightness " + edited);

                    saveValue(".dimmer_all_monitors.txt", edited);

                    if ((slider.adjustment.value / 100) > 1.2) slider.tooltip_text = "Too Bright";
                    else if ((slider.adjustment.value / 100) < 0.6) slider.tooltip_text = "Too Dark";
                    else slider.tooltip_text = "";
            } catch (SpawnError se) {}
        });
        
        //.v.positioning
        vboxMain.add(slider);
    
        if (lines.size > 1) {
            for (int i = 0; i < lines.size; i++) {
                if (i == 0) {
                    vboxInd.add(label1);
                    vboxInd.add(slider1);
                }
                else if (i == 1) {
                    vboxInd.add(label2);
                    vboxInd.add(slider2);
                }
                else if (i == 2) {
                    vboxInd.add(label3);
                    vboxInd.add(slider3);
                }
                else if (i == 3) {
                    vboxInd.add(label4);
                    vboxInd.add(slider4);
                }
            }
        }
        
        vboxMain.pack_end(vboxInd, false, false, 0);
        
        window.add(vboxMain);
        
        window.show_all();
    }

    //also, if only 1 monitor exists    
    private static void setValueForAll() {
        string prevValue;
                    
        if (FileUtils.test(".dimmer_all_monitors.txt", GLib.FileTest.EXISTS) == true) {
            try {
                FileUtils.get_contents(".dimmer_all_monitors.txt", out prevValue);
            }
            catch(Error e) {
                prevValue = "1.00";
                stderr.printf ("Error: %s\n", e.message);
            }
        }
        else {
            prevValue = "1.00"; //default
        }
        
        double dprevValue = double.parse(prevValue);
        if (dprevValue<0.4) dprevValue = 0.4;
        if (dprevValue>1.5) dprevValue = 1.5;
        
        slider.adjustment.value = dprevValue * 100;
                
        string edited = dprevValue.to_string();
            
        try {    
            for (int i = 0; i < lines.size; i++) GLib.Process.spawn_command_line_async("xrandr --output " + lines.get(i) + " --brightness " + edited);
        } catch (SpawnError se) {}
    }
    
    //if more than 1 monitor exists
    private static void setValuesForEveryMonitor() {
        for (int i = 0; i < lines.size; i++) {
            string prevValue;
            
            if (monitors[i] != "") {
                if (FileUtils.test(".dimmer_"+monitors[i]+".txt", GLib.FileTest.EXISTS) == true) {
                    try {
                        FileUtils.get_contents(".dimmer_"+monitors[i]+".txt", out prevValue);
                    }
                    catch(Error e) {
                        prevValue = "1.00";
                        stderr.printf ("Error: %s\n", e.message);
                    }
                }
                else {
                    prevValue = "1.00"; //default
                }
                
                double dprevValue = double.parse(prevValue);
                if (dprevValue < 0.4) dprevValue = 0.4;
                if (dprevValue > 1.5) dprevValue = 1.5;
                
                if (i==0) slider1.adjustment.value = dprevValue * 100;
                else if (i==1) slider2.adjustment.value = dprevValue * 100;
                else if (i==2) slider3.adjustment.value = dprevValue * 100;
                else if (i==3) slider4.adjustment.value = dprevValue * 100;
                
                string edited = dprevValue.to_string();
                
                try {
                    GLib.Process.spawn_command_line_async("xrandr --output " + monitors[i] + " --brightness " + edited);
                } catch (SpawnError se) {}
            }
        }
    }
    
    private static void saveValue(string filename, string valueToSave) {
        try {
            FileUtils.set_contents(filename, valueToSave);
        }
        catch(Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }
    
    public static int main(string[] args) { 
        return new Dimmer().run (args); 
    }
}
