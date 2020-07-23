const debug = @import("std").debug;
const c = @cImport
({
    @cInclude("SDL2/SDL.h");
});

pub fn main() !void
{
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0)
    {
        return error.SDL_Init;
    }
    defer c.SDL_Quit();

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
    defer c.SDL_DestroyWindow(window);

    const renderer = c.SDL_CreateRenderer
    (
        window, -1, 0
    ) orelse return error.SDL_CreateRenderer;
    defer c.SDL_DestroyRenderer(renderer);

    const bytesPerPixel = 4;
    const width = 1024;
    const height = 768;

    const texture = c.SDL_CreateTexture
    (
        renderer,
        c.SDL_PIXELFORMAT_RGBA8888,
        c.SDL_TEXTUREACCESS_STATIC,
        width, height
    ) orelse return error.SDL_CreateTexture;
    defer c.SDL_DestroyTexture(texture);

    var memory = [_]u32{0} ** (width * height);

    if (c.SDL_UpdateTexture
    (
        texture,
        null,
        &memory,
        width * bytesPerPixel
    ) != 0)
    {
        return error.SDL_UpdateTexture;
    }

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
                c.SDL_Log("Window event: SDL_WINDOWEVENT_CLOSE");
                app_running = false;
            }
        }

        if (c.SDL_RenderCopy(renderer, texture, null, null) != 0)
        {
            return error.SDL_RenderCopy;
        }
    }
}
