class control_unit_monitor extends uvm_monitor;
    `uvm_component_utils(control_unit_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual control_unit_if.MONITOR vif;

    uvm_analysis_port #(control_unit_item) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon_analysis_port = new("mon_analysis_port", this);

        if(!uvm_config_db #(virtual control_unit_if.MONITOR)::get(this, "", "vif", vif))
            `uvm_error(get_type_name(), "Didn't get handle to virtual interface control_unit_if");
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        control_unit_item tr;

        if(vif == null)
            return;

        forever begin
            @(vif.control_unit_cbm);

            tr = control_unit_item::type_id::create("tr", this);

            tr.instr = vif.control_unit_cbm.instr;
            tr.reg_en = vif.control_unit_cbm.reg_en;
            tr.regmux = vif.control_unit_cbm.regmux;
            tr.alumux1 = vif.control_unit_cbm.alumux1;
            tr.alumux2 = vif.control_unit_cbm.alumux2;
            tr.alu_sel = vif.control_unit_cbm.alu_sel;
            tr.mul_sel = vif.control_unit_cbm.mul_sel;
            tr.jump = vif.control_unit_cbm.jump;
            tr.br_en = vif.control_unit_cbm.br_en;
            tr.jalr = vif.control_unit_cbm.jalr;
            tr.we = vif.control_unit_cbm.we;
            tr.sz = vif.control_unit_cbm.sz;
            tr.num_bytes = vif.control_unit_cbm.num_bytes;

            mon_analysis_port.write(tr);
        end

    endtask : run_phase

endclass : control_unit_monitor