import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"

export default function Time() {
    const time = createPoll("", 1000, "date '+%a %b %d %I:%M:%S %p'")

    return (
        <menubutton cssName="Time" class="bar-module">
            <label label={time} />
            <popover hasArrow={false}>
                <Gtk.Calendar />
            </popover>
        </menubutton>
    )
}
