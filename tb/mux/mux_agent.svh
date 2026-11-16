class mux_agent extends uvm_agent;
    `uvm_component_utils(mux_agent)

    mux_driver m_driver;
    mux_monitor m_monitor;
    mux_sequencer m_sequencer;
    mux_coverage m_coverage;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(get_is_active()) begin
            m_sequencer = mux_sequencer::type_id::create("m_sequencer", this);
            m_driver = mux_driver::type_id::create("m_driver", this);
        end

        m_monitor = mux_monitor::type_id::create("m_monitor", this);
        m_coverage = mux_coverage::type_id::create("m_coverage", this);

    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(get_is_active())
            m_driver.seq_item_port.connect(m_sequencer.seq_item_export);

        m_monitor.mon_analysis_port.connect(m_coverage.analysis_export);
    endfunction : connect_phase

endclass : mux_agent