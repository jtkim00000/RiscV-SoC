class mux_coverage extends uvm_subscriber #(mux_item);
    `uvm_component_utils(mux_coverage)

    covergroup cg_mux_transaction with function sample(
        bit [31:0] a,
        bit [31:0] b,
        logic [31:0] s
    );
        // No coverage bins needed
    endgroup : cg_mux_transaction

    mux_item trans;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_mux_transaction = new();
    endfunction : new

    virtual function void write(mux_item t);
        cg_mux_transaction.sample(t.data_in, t.sel, t.data_out);
    endfunction : write
endclass : mux_coverage