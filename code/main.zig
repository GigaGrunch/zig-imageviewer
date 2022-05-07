const debug = @import("std").debug;
const sdl = @cImport(@cInclude("SDL.h"));

pub fn main() !void {
    if (sdl.SDL_Init(sdl.SDL_INIT_VIDEO) != 0) {
        return error.SDL_Init;
    }
    defer sdl.SDL_Quit();

    sdl.SDL_Log("Hello World!");
    defer sdl.SDL_Log("Bye bye!");

    const window = sdl.SDL_CreateWindow(
        "Image Viewer",
        sdl.SDL_WINDOWPOS_UNDEFINED,
        sdl.SDL_WINDOWPOS_UNDEFINED,
        1024, 768,
        sdl.SDL_WINDOW_RESIZABLE
    ) orelse return error.SDL_CreateWindow;
    defer sdl.SDL_DestroyWindow(window);

    const renderer = sdl.SDL_CreateRenderer(
        window, -1, 0
    ) orelse return error.SDL_CreateRenderer;
    defer sdl.SDL_DestroyRenderer(renderer);

    const bytesPerPixel = 4;
    const width = 1024;
    const height = 768;

    const texture = sdl.SDL_CreateTexture(
        renderer,
        sdl.SDL_PIXELFORMAT_RGBA8888,
        sdl.SDL_TEXTUREACCESS_STATIC,
        width, height
    ) orelse return error.SDL_CreateTexture;
    defer sdl.SDL_DestroyTexture(texture);

    var memory = [_]u32{0} ** (width * height);

    if (sdl.SDL_UpdateTexture(
        texture,
        null,
        &memory,
        width * bytesPerPixel
    ) != 0) return error.SDL_UpdateTexture;

    var app_running = true;
    while (app_running) {
        var event: sdl.SDL_Event = undefined;
        if (sdl.SDL_WaitEvent(&event) == 0) {
            return error.SDL_WaitEvent;
        }

        if (event.type == sdl.SDL_WINDOWEVENT) {
            const window_event = event.window;
            if (window_event.event == sdl.SDL_WINDOWEVENT_CLOSE) {
                sdl.SDL_Log("Window event: SDL_WINDOWEVENT_CLOSE");
                app_running = false;
            }
        }

        if (sdl.SDL_RenderCopy(renderer, texture, null, null) != 0) {
            return error.SDL_RenderCopy;
        }

        sdl.SDL_RenderPresent(renderer);
    }
}
