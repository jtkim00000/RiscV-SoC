class uartr_coverage extends uvm_subscriber #(uartr_item);
    `uvm_component_utils(uartr_coverage)

    covergroup cg_uartr_transaction with function sample(
        bit reset,
        bit start
    );
        option.per_instance = 1;

        cp_reset: coverpoint reset {
            bins receive_cycle  = {0};
            bins reset_cycle = {1};
        }

        cp_start: coverpoint start {
            bins idle  = {0};
            bins receive = {1};
        }

    endgroup : cg_uartr_transaction

    uartr_item trans;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_uartr_transaction = new();
    endfunction : new

    virtual function void write(uartr_item t);
        cg_uartr_transaction.sample(t.reset, t.start);
    endfunction : write
endclass : uartr_coverage