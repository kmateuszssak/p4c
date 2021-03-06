//
// Created by p4dev on 08.04.19.
//

#ifndef P4C_UBPFPROGRAM_H
#define P4C_UBPFPROGRAM_H

#include "target.h"
#include "backends/ebpf/ebpfModel.h"
#include "ir/ir.h"
#include "frontends/p4/typeMap.h"
#include "frontends/p4/evaluator/evaluator.h"
#include "backends/ebpf/ebpfProgram.h"
#include "ubpfParser.h"

namespace UBPF {

class UbpfProgram : public EBPF::EBPFProgram {
public:
    UBPFParser* parser;

    UbpfProgram(const CompilerOptions &options, const IR::P4Program* program,
                P4::ReferenceMap* refMap, P4::TypeMap* typeMap, const IR::ToplevelBlock* toplevel) :
                EBPF::EBPFProgram(options, program, refMap, typeMap, toplevel) {

    }

    bool build() override;
    void emitC(EBPF::CodeBuilder* builder, cstring headerFile) override;
    void emitH(EBPF::CodeBuilder* builder, cstring headerFile) override;
    void emitTypes(EBPF::CodeBuilder* builder) override;
    void emitPipeline(EBPF::CodeBuilder* builder) override;
    void emitUbpfHelpers(EBPF::CodeBuilder* builder) const;
};

} // namespace UBPF

#endif //P4C_UBPFPROGRAM_H
