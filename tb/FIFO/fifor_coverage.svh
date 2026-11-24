class fifor_coverage extends uvm_subscriber #(fifor_item);
    `uvm_component_utils(fifor_coverage)

    covergroup cg_fifor_transaction with function sample(
        bit reset,
        logic full,
        logic empty
    );
        option.per_instance = 1;

        cp_reset: coverpoint reset {
            bins load_cycle  = {0};
            bins reset_cycle = {1};
        }

        cp_full: coverpoint full {
            bins not_full  = {0};
            bins full = {1};
        }
        
        cp_empty: coverpoint empty {
            bins not_empty  = {0};
            bins empty = {1};
        }

    endgroup : cg_fifor_transaction

    fifor_item trans;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_fifor_transaction = new();
    endfunction : new

    virtual function void write(fifor_item t);
        cg_fifor_transaction.sample(t.reset, t.full, t.empty);
    endfunction : write
endclass : fifor_coverage