using Gtk;

public class Brightness : Gtk.Application {

     public Brightness () {
        Object (
            application_id: "com.github.panosx2.brightness",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var window = new Gtk.ApplicationWindow(this);
        window.title = "Brightness";
        window.set_default_size(450,150);
        window.destroy.connect(Gtk.main_quit);
        try {
        window.set_icon(new Gdk.Pixbuf.from_file("brightness.png"));
        }
        catch (GLib.Error gl) { print("no icon");}
        window.window_position = WindowPosition.CENTER;
        window.border_width = 7;

        //find current
        string current = "100";
        string findCurrentCommand = "sh -c \"xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' '\"";
        try {
        GLib.Process.spawn_command_line_sync(findCurrentCommand, out current);
        }
        catch (SpawnError se) {
        current = "100";
        }
        double fixedCurrent = double.parse(current);
        fixedCurrent = fixedCurrent*100;

        //get names
        string  getNamesCommand = "sh -c \"xrandr | grep ' connected ' | awk '{ print$1 }'\"";
        string names = "";
        try {
        GLib.Process.spawn_command_line_sync(getNamesCommand, out names);
        }
        catch (SpawnError se) {
        }
        string[] lines = names.split("\n");

        //slider
        var slider = new Scale.with_range (Orientation.HORIZONTAL, 50, 100, 1);
        slider.adjustment.value = fixedCurrent;
        slider.adjustment.value_changed.connect (() => {
        try {
        string level = slider.adjustment.value.to_string();
        string editedLevel;
        if (slider.adjustment.value != 100) editedLevel = "0." + level;
        else editedLevel = "1.0";

        for (int i=0; i<lines.length; i++) {
        GLib.Process.spawn_command_line_async("xrandr --output "+lines[i]+" --brightness " + editedLevel);
        }

        }
        catch (SpawnError se) {
        }

        });

        window.add(slider);
        window.show_all();
    }

    public static int main(string[] args) {
        var app = new Brightness ();
        return app.run (args);
    }
}
