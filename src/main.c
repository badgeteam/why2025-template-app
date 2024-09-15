
// SPDX-License-Identifier: CC0-1.0
// Copyright © 2024, Badge.team

#include "main.h"

#include "bsp.h"
#include "bsp_pax.h"

void main() {
    // Get a framebuffer for our screen, courtesy of the BSP.
    pax_buf_t *gfx = bsp_pax_buf_from_ep(1, 0);

    // Draw some stuff.
    pax_background(gfx, 0xffff0000);
    pax_vec2i   dims = pax_buf_get_dims(gfx);
    char const *msg  = "Hello, World!";
    printf("My message: %s\n", msg);
    pax_draw_text_adv(
        gfx,
        0xffffffff,
        pax_font_saira_condensed,
        pax_font_saira_condensed->default_size,
        dims.x / 2,
        dims.y / 2,
        msg,
        strlen(msg),
        PAX_ALIGN_CENTER,
        PAX_ALIGN_CENTER,
        -1
    );
    pax_join();

    // Send it to the screen.
    bsp_disp_update(1, 0, pax_buf_get_pixels(gfx));

    // Wait for something to happen.
    bsp_event_t event;
    bsp_event_wait(&event, UINT64_MAX);

    // Clean up.
    pax_buf_destroy(gfx);
}
