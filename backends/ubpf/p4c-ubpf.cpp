#include <stdio.h>
#include <string>
#include <iostream>

#include "lib/gc.h"
#include "lib/crash.h"

#include "backends/ebpf/midend.h"
#include "backends/ebpf/ebpfOptions.h"

int main(int argc, char *const argv[]) {
    setup_gc_logging();
    setup_signals();

    AutoCompileContext autoEbpfContext(new EbpfContext);
    auto& options = EbpfContext::get().options();
    options.compilerVersion = "0.0.1-beta";



    if(Log::verbose())
        std::cerr << "Done." << std:endl;

    return ::errorCount() > 0;

}

