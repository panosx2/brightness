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

public class Dimmer.Indicator : Wingpanel.Indicator {
    private Wingpanel.Widgets.OverlayIcon display_widget;    
    private Gtk.Box vboxMain;
    
    public Indicator () {
        Object (
            code_name : "dimmer",
            display_name : _("Dimmer"),
            description: _("Change brightness")
        );
    }
    
    construct {
        display_widget = new Wingpanel.Widgets.OverlayIcon ("com.github.panosx2.brightness");
        
        this.visible = true;
        
        vboxMain = new Widgets.DisplayWidget().take();
    }
    
    public override Gtk.Widget get_display_widget () {
        return display_widget;
    }

    public override Gtk.Widget? get_widget () {
        return vboxMain;
    }
    
    public override void opened () {
    }

    public override void closed () {
    }
}
    
public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    debug ("Activating Dimmer indicator");

    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
         debug ("Wingpanel is not in session, not loading Dimmer indicator");
        return null;
    }

    var indicator = new Dimmer.Indicator ();

    return indicator;
}
