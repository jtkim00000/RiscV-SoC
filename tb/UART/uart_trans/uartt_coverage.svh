class uartt_coverage extends uvm_subscriber #(uartt_item);
    `uvm_component_utils(uartt_coverage)

    covergroup cg_uartt_transaction with function sample(
        bit reset,
        bit start
    );
        option.per_instance = 1;

        cp_reset: coverpoint reset {
            bins transmit_cycle  = {0};
            bins reset_cycle = {1};
        }

        cp_start: coverpoint start {
            bins idle  = {0};
            bins transmit = {1};
        }

    endgroup : cg_uartt_transaction

    uartt_item trans;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_uartt_transaction = new();
    endfunction : new

    virtual function void write(uartt_item t);
        cg_uartt_transaction.sample(t.reset, t.start);
    endfunction : write
endclass : uartt_coverage