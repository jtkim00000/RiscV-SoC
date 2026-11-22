class uartr_coverage extends uvm_subscriber #(uartr_item);
    `uvm_component_utils(uartr_coverage)

    covergroup cg_uartr_transaction with function sample(
        bit reset,
        logic [7:0] send_data
    );
        option.per_instance = 1;

        cp_reset: coverpoint reset {
            bins receive_cycle  = {0};
            bins reset_cycle = {1};
        }

        cp_accepted_data: coverpoint send_data
            iff (!reset) {
                bins zero        = {8'h00};
                bins all_ones    = {8'hFF};
                bins alternating[] = {8'h55, 8'hAA};
                bins other       = default;
            }

    endgroup : cg_uartr_transaction

    uartr_item trans;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_uartr_transaction = new();
    endfunction : new

    virtual function void write(uartr_item t);
        cg_uartr_transaction.sample(t.reset, t.send_data);
    endfunction : write
endclass : uartr_coverage