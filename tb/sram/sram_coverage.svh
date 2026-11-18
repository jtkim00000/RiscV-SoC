class sram_coverage extends uvm_subscriber #(sram_item);
    `uvm_component_utils(sram_coverage)

    covergroup cg_sram_transaction with function sample(sram_item t);
        option.per_instance = 1;

        cp_reset: coverpoint t.write_enable {
            bins read_cycle  = {0};
            bins write_cycle = {1};
        }

        cp_sz: coverpoint t.sz {
            bins zero_ext  = {0};
            bins sign_ext = {1};
        }

        cp_num_bytes: coverpoint t.num_bytes {
            bins one = {0};
            bins two = {1};
            bins four = {2};
        }

    endgroup : cg_sram_transaction

    sram_item trans;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_sram_transaction = new();
    endfunction : new

    virtual function void write(sram_item t);
        cg_sram_transaction.sample(t);
    endfunction : write
endclass : sram_coverage