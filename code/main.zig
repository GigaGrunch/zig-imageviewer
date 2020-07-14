const debug = @import("std").debug;
const c = @cImport(@cInclude("SDL2/SDL.h"));

pub fn main() !void
{
    c.SDL_Log("Hello World!");
    defer c.SDL_Log("Bye bye!");

    const window = c.SDL_CreateWindow
    (
        "Image Viewer",
        c.SDL_WINDOWPOS_UNDEFINED,
        c.SDL_WINDOWPOS_UNDEFINED,
        1024, 768,
        c.SDL_WINDOW_RESIZABLE
    ) orelse return error.SDL_CreateWindow;

    var app_running = true;
    while (app_running)
    {
        var event: c.SDL_Event = undefined;
        if (c.SDL_WaitEvent(&event) == 0)
        {
            return error.SDL_WaitEvent;
        }

        if (event.type == c.SDL_WINDOWEVENT)
        {
            const window_event = event.window;
            if (window_event.event == c.SDL_WINDOWEVENT_CLOSE)
            {
                c.SDL_Log("Quitting");
                app_running = false;
            }
        }
    }
}

const SDLError = error
{
    SDL_CreateWindow,
    SDL_WaitEvent
};
