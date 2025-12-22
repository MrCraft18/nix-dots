import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { execAsync } from "ags/process"
import Time from "./Modules/Time"

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return (
        <window
            visible
            name="Bar"
            gdkmonitor={gdkmonitor}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
            application={app}
        >
            <centerbox cssName="centerbox">
                <box cssName="left-container" $type="start"  >
                    <label label="Middle" />
                </box>

                <box cssName="center-container" $type="center"  >
                    <Time />
                </box>

                <box cssName="right-container" $type="end"  >
                    <label label="Over Here" />
                </box>
            </centerbox>
        </window>
    )
}
