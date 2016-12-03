#include <core.p4>
#include <v1model.p4>

struct metadata_t {
    bit<8> val;
}

header data_t {
    bit<32> f1;
    bit<32> f2;
    bit<16> h1;
    bit<8>  b1;
    bit<8>  b2;
}

struct metadata {
    @name("meta") 
    metadata_t meta;
}

struct headers {
    @name("data") 
    data_t data;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("start") state start {
        packet.extract<data_t>(hdr.data);
        transition accept;
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("NoAction_2") action NoAction_0() {
    }
    @name("copyb1") action copyb1_0() {
        hdr.data.b1 = meta.meta.val;
    }
    @name("output") table output() {
        actions = {
            copyb1_0();
            NoAction_0();
        }
        default_action = copyb1_0();
    }
    apply {
        output.apply();
    }
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("NoAction_3") action NoAction_1() {
    }
    @name("NoAction_4") action NoAction_5() {
    }
    @name("setb1") action setb1_0(bit<8> val, bit<9> port) {
        meta.meta.val = val;
        standard_metadata.egress_spec = port;
    }
    @name("noop") action noop_0() {
    }
    @name("noop") action noop_2() {
    }
    @name("test1") table test1() {
        actions = {
            setb1_0();
            noop_0();
            NoAction_1();
        }
        key = {
            hdr.data.f1: exact;
        }
        default_action = NoAction_1();
    }
    @name("test2") table test2() {
        actions = {
            noop_2();
            NoAction_5();
        }
        key = {
            meta.meta.val: exact;
        }
        default_action = NoAction_5();
    }
    apply {
        test1.apply();
        test2.apply();
    }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit<data_t>(hdr.data);
    }
}

control verifyChecksum(in headers hdr, inout metadata meta) {
    apply {
    }
}

control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

V1Switch<headers, metadata>(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;