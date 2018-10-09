/*
* Copyright (c) 2018 Panos P. (https://github.com/panosx2/brightness)
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

namespace Brightness { public class Brightness : Gtk.Application {
    public Brightness () { Object (application_id: "com.github.panosx2.brightness",flags: ApplicationFlags.FLAGS_NONE); }
    protected override void activate () {
        var window = new Gtk.ApplicationWindow(this);
        window.title = "Brightness";
        window.set_default_size(450,130);
        window.destroy.connect(Gtk.main_quit);
        window.window_position = WindowPosition.CENTER;
        window.border_width = 7;
        try { window.set_icon(new Gdk.Pixbuf.from_file("icons/64/com.github.panosx2.brightness.png")); } catch (GLib.Error ge) {}
        string current;
        try { GLib.Process.spawn_command_line_sync("sh -c \"xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '\"",out current); } catch (SpawnError se) { current = "100"; }
        string names;
        try { GLib.Process.spawn_command_line_sync("sh -c \"xrandr | grep ' connected ' | awk '{ print$1 }'\"",out names); } catch (SpawnError se) { names = ""; }
        string[] lines = names.split("\n");
        var slider = new Scale.with_range(Orientation.HORIZONTAL, 50, 100, 1);
        slider.adjustment.value = double.parse(current)*100;
        slider.adjustment.value_changed.connect (() => {
        try {
        string edited = (slider.adjustment.value != 100)?("0."+slider.adjustment.value.to_string()):"1.0";
        for (int i=0; i<lines.length; i++) { GLib.Process.spawn_command_line_async("xrandr --output "+lines[i]+" --brightness "+edited); }}
        catch (SpawnError se) {}});
        window.add(slider);
        window.show_all();}
    public static int main(string[] args) {return new Brightness().run (args);}
}}
