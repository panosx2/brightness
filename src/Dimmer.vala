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
using AppIndicator;

public class Dimmer : Indicator {
    public static Window window;
    public static Gtk.Scale slider;
    public static AppIndicator.Indicator indicator;
    public static Gtk.Scale slider1;
    public static Gtk.Scale slider2;
    public static Gtk.Scale slider3;
    public static Gtk.Scale slider4;
    
    public static bool previousOpened;

    public static int main(string[] args) {
	Gtk.init(ref args);
		
	previousOpened = false;

        createWindow();

        indicator = new Indicator("Dimmer", "com.github.panosx2.brightness", IndicatorCategory.APPLICATION_STATUS);
        indicator.set_status(IndicatorStatus.ACTIVE);
        indicator.set_attention_icon("com.github.panosx2.brightness");

        var menu = new Gtk.Menu();

        var open = new Gtk.MenuItem.with_label("Open");
        open.activate.connect(showWindow);
        open.show();
        menu.append(open);

        var quit = new Gtk.MenuItem.with_label("Quit");
        quit.activate.connect(Gtk.main_quit);
        quit.show();
        menu.append(quit);

        indicator.set_menu(menu);

        Gtk.main();

        return 0;
    }

    public static void createWindow() {
        window = new Window();
        window.title = "Dimmer";
        window.window_position = WindowPosition.CENTER;
        window.set_decorated(true);
        window.set_deletable(false);
        window.set_resizable(false);
        window.border_width = 20;
        
        var close = new Button.with_label("Close");
        close.set_margin_left(120);
        close.set_margin_right(120);
        close.clicked.connect(() => { 
            previousOpened = true;
            window.hide();
        });
        
        var vboxMain = new Box (Orientation.VERTICAL, 0);
        vboxMain.homogeneous = false;
        
        vboxMain.pack_end(close, false, true, 0);
        
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

        string[] lines = names.split("\n");
        
        if (lines.length > 1) {
            var hboxAll = new Box (Orientation.HORIZONTAL, 0);
            hboxAll.homogeneous = false;
        
            var label = new Label("All Monitors:");
            label.halign = Align.START;
            
            var switcher = new Switch();
            switcher.active = true;
            switcher.state_changed.connect(() => {
                if (switcher.active == true) {
                    slider.visible = true; 
                    vboxInd.visible = false;
                    slider.adjustment.value = slider.get_value();
                }
                else {
                    slider.visible = false;
                    vboxInd.visible = true;
                    slider1.set_value(slider1.get_value());
                    slider2.set_value(slider2.get_value());
                    slider3.set_value(slider3.get_value());
                    slider4.set_value(slider4.get_value());
                }
            });
            
            hboxAll.pack_start(label, false, false, 0);
            hboxAll.pack_end(switcher, false, false, 0);
            
            vboxMain.add(hboxAll);
        }
        
        string[] monitors = {"", "", "", ""};
        
        for (int i = 0; i < lines.length - 1; i++) {
            monitors[i] = lines[i];
        }
        
        if (lines.length > 1) {
            //slider1
            Label label1 = new Label(monitors[0]);
            label1.halign = Align.START;
            
            try {
                    GLib.Process.spawn_command_line_sync("sh -c \"xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '\"", out currentBr);
                 } catch (SpawnError se) { currentBr = "100"; }
            
            slider1 = new Scale.with_range(Orientation.HORIZONTAL, 40, 150, 1);
            slider1.set_size_request(380, 30);
            slider1.adjustment.value = double.parse(currentBr) * 100;
            slider1.adjustment.value_changed.connect (() => {
                try {
                        string edited = (slider1.adjustment.value / 100).to_string();

                        if ((slider1.adjustment.value / 100) >= 1.0) {
                            GLib.Process.spawn_command_line_async("xrandr --output " + monitors[0] + " --gamma " + edited + ":" + edited + ":" + edited);
                        }
                        else GLib.Process.spawn_command_line_async("xrandr --output " + monitors[0] + " --brightness " + edited);

                        if ((slider1.adjustment.value / 100) > 1.2) slider1.tooltip_text = "Too Bright";
                        else if ((slider1.adjustment.value / 100) < 0.6) slider1.tooltip_text = "Too Dark";
                        else slider1.tooltip_text = "";
                } catch (SpawnError se) {}
            });
            slider1.set_margin_bottom(20);
            
            //slider2
            Label label2 = new Label(monitors[1]);
            label2.halign = Align.START;
            
            try {
                GLib.Process.spawn_command_line_sync("sh -c \"xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '\"", out currentBr);
                 } catch (SpawnError se) { currentBr = "100"; }
            
            slider2 = new Scale.with_range(Orientation.HORIZONTAL, 40, 150, 1);
            slider2.set_size_request(380, 30);
            slider2.adjustment.value = double.parse(currentBr) * 100;
            slider2.adjustment.value_changed.connect (() => {
                try {
                        string edited = (slider2.adjustment.value / 100).to_string();

                        if ((slider2.adjustment.value / 100) >= 1.0) {
                            GLib.Process.spawn_command_line_async("xrandr --output " + monitors[1] + " --gamma " + edited + ":" + edited + ":" + edited);
                        }
                        else GLib.Process.spawn_command_line_async("xrandr --output " + monitors[1] + " --brightness " + edited);

                        if ((slider2.adjustment.value / 100) > 1.2) slider2.tooltip_text = "Too Bright";
                        else if ((slider2.adjustment.value / 100) < 0.6) slider2.tooltip_text = "Too Dark";
                        else slider2.tooltip_text = "";
                } catch (SpawnError se) {}
            });
            slider2.set_margin_bottom(20);
            
            //slider3
            Label label3 = new Label(monitors[2]);
            label3.halign = Align.START;
            
            try {
                    GLib.Process.spawn_command_line_sync("sh -c \"xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '\"", out currentBr);
                 } catch (SpawnError se) { currentBr = "100"; }
            
            slider3 = new Scale.with_range(Orientation.HORIZONTAL, 40, 150, 1);
            slider3.set_size_request(380, 30);
            slider3.adjustment.value = double.parse(currentBr) * 100;
            slider3.adjustment.value_changed.connect (() => {
                try {
                        string edited = (slider3.adjustment.value / 100).to_string();

                        if ((slider3.adjustment.value / 100) >= 1.0) {
                            GLib.Process.spawn_command_line_async("xrandr --output " + monitors[2] + " --gamma " + edited + ":" + edited + ":" + edited);
                        }
                        else GLib.Process.spawn_command_line_async("xrandr --output " + monitors[2] + " --brightness " + edited);

                        if ((slider3.adjustment.value / 100) > 1.2) slider3.tooltip_text = "Too Bright";
                        else if ((slider3.adjustment.value / 100) < 0.6) slider3.tooltip_text = "Too Dark";
                        else slider3.tooltip_text = "";
                } catch (SpawnError se) {}
            });
            slider3.set_margin_bottom(20);
            
            //slider4
            Label label4 = new Label(monitors[3]);
            label4.halign = Align.START;
            
            try {
                    GLib.Process.spawn_command_line_sync("sh -c \"xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '\"", out currentBr);
                 } catch (SpawnError se) { currentBr = "100"; }
            
            slider4 = new Scale.with_range(Orientation.HORIZONTAL, 40, 150, 1);
            slider4.set_size_request(380, 30);
            slider4.adjustment.value = double.parse(currentBr) * 100;
            slider4.adjustment.value_changed.connect (() => {
                try {
                        string edited = (slider4.adjustment.value / 100).to_string();

                        if ((slider4.adjustment.value / 100) >= 1.0) {
                            GLib.Process.spawn_command_line_async("xrandr --output " + monitors[3] + " --gamma " + edited + ":" + edited + ":" + edited);
                        }
                        else GLib.Process.spawn_command_line_async("xrandr --output " + monitors[3] + " --brightness " + edited);

                        if ((slider4.adjustment.value / 100) > 1.2) slider4.tooltip_text = "Too Bright";
                        else if ((slider4.adjustment.value / 100) < 0.6) slider4.tooltip_text = "Too Dark";
                        else slider4.tooltip_text = "";
                } catch (SpawnError se) {}
            });
            slider4.set_margin_bottom(20);
            
            //slider for all monitors
            slider = new Scale.with_range(Orientation.HORIZONTAL, 40, 150, 1);
            slider.set_size_request(380, 50);
            slider.adjustment.value = double.parse(currentBr) * 100;
            slider.adjustment.value_changed.connect (() => {  
                try {
                        string edited = (slider.adjustment.value / 100).to_string();

                        for (int i = 0; i < lines.length - 1; i++) {
                            if ((slider.adjustment.value / 100) >= 1.0) {
                                GLib.Process.spawn_command_line_async("xrandr --output " + lines[i] + " --gamma " + edited + ":" + edited + ":" + edited);
                            }
                            else GLib.Process.spawn_command_line_async("xrandr --output " + lines[i] + " --brightness " + edited);
                        }
                        
                        if (lines.length > 1) {
                            for (int j = 0; j < lines.length - 1; j++) {
                                if (j == 0) slider1.adjustment.value = slider.adjustment.value;
                                else if (j == 1) slider2.adjustment.value = slider.adjustment.value;
                                else if (j == 2) slider3.adjustment.value = slider.adjustment.value;
                                else if (j == 3) slider4.adjustment.value = slider.adjustment.value;
                            }
                        }

                        if ((slider.adjustment.value / 100) > 1.2) slider.tooltip_text = "Too Bright";
                        else if ((slider.adjustment.value / 100) < 0.6) slider.tooltip_text = "Too Dark";
                        else slider.tooltip_text = "";
                } catch (SpawnError se) {}
            });
            slider.set_margin_bottom(20);
            
            vboxMain.add(slider);
        
            for (int i = 0; i < lines.length - 1; i++) {
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
        
        vboxMain.pack_end(vboxInd, false, false, 20);
        
        window.add(vboxMain);
    }

    public static void showWindow() {
        if (previousOpened) window.present();
        else window.show_all();
    }
}
