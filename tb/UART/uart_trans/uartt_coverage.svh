class uartt_coverage extends uvm_subscriber #(uartt_item);
    `uvm_component_utils(uartt_coverage)

    covergroup cg_uartt_transaction with function sample(
        bit reset,
        bit start,
        bit busy,
        logic [7:0] data
    );
        option.per_instance = 1;

        cp_reset: coverpoint reset {
            bins transmit_cycle  = {0};
            bins non_reset_cycle = {1};
        }

        cp_accepted_data: coverpoint data
            iff (!reset && start && !busy) {
                bins zero        = {8'h00};
                bins all_ones    = {8'hFF};
                bins alternating[] = {8'h55, 8'hAA};
                bins other       = default;
            }

    endgroup : cg_uartt_transaction

    uartt_item trans;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_uartt_transaction = new();
    endfunction : new

    virtual function void write(uartt_item t);
        cg_uartt_transaction.sample(t.reset, t.start, t.busy, t.data);
    endfunction : write
endclass : uartt_coverage