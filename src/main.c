
#include "bsp.h"

#include <stdio.h>

static bsp_event_t event;

void _start() {
    printf("Hello, World!\n");
    printf("Funny app is waiting for event...\n");
    bsp_event_wait(&event, UINT64_MAX);
    printf("There is an event!\n");
}
