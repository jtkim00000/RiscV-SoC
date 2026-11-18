class mux_coverage extends uvm_subscriber #(mux_item_t);
    `uvm_component_utils(mux_coverage)

    covergroup cg_mux_transaction with function sample(mux_item_t tr);
        option.per_instance = 1;

        cp_sel: coverpoint tr.sel {
            bins inputs[] = {[0:3]};
        }
    endgroup : cg_mux_transaction

    mux_item trans;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_mux_transaction = new();
    endfunction : new

    virtual function void write(mux_item_t t);
        cg_mux_transaction.sample(t);
    endfunction : write
endclass : mux_coverage