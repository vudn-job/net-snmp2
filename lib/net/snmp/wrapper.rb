module Net
module SNMP
module Wrapper
  extend NiceFFI::Library
  ffi_lib "/opt/local/lib/libnetsnmp.dylib"
  #ffi_lib "netsnmp"
  typedef :u_long, :oid

  class Counter64 < NiceFFI::Struct
    layout(
           :high, :u_long,
           :low, :u_long
    )
  end
  
  class TimeVal < NiceFFI::Struct
    layout(:tv_sec, :long, :tv_usec, :long)
  end
  
  
  class NetsnmpVardata < FFI::Union
    layout(
           :integer, :pointer,
           :string, :pointer,
           :objid, :pointer,
           :bitstring, :pointer,
           :counter64, :pointer,
           :float, :pointer,
           :double, :pointer
    )
  end
 # puts "Vardata size = #{NetsnmpVardata.size}"
  class VariableList < NiceFFI::Struct
    layout(
           :next_variable, :pointer,
           :name, :pointer,
           :name_length, :size_t,
           :type, :u_char,
           :val, NetsnmpVardata,
           :val_len, :size_t,
           :name_loc, [:oid, Net::SNMP::MAX_OID_LEN],
           :buf, [:u_char, 40],
           :data, :pointer,
           :dataFreeHook, callback([ :pointer ], :void),
           :index, :int
    )  
  end
  
  #puts "VariableList size = #{VariableList.size}"

  class SnmpPdu < NiceFFI::Struct
    layout(
           :version, :long,
           :command, :int,
           :reqid, :long,
           :msgid, :long,
           :transid, :long,
           :sessid, :long,
           :errstat, :long,
           :errindex, :long,
           :time, :u_long,
           :flags, :u_long,
           :securityModel, :int,
           :securityLevel, :int,
           :msgParseModel, :int,
           :transport_data, :pointer,
           :transport_data_length, :int,
           :tDomain, :pointer,
           :tDomainLen, :size_t,
           :variables, VariableList.typed_pointer,
           :community, :pointer,
           :community_len, :size_t,
           :enterprise, :pointer,
           :enterprise_length, :size_t,
           :trap_type, :long,
           :specific_type, :long,
           :agent_addr, [:uchar, 4],
           :contextEngineID, :pointer,
           :contextEngineIDLen, :size_t,
           :contextName, :pointer,
           :contextNameLen, :size_t,
           :securityEngineID, :pointer,
           :securityEngineIDLen, :size_t,
           :securityName, :pointer,
           :securityNameLen, :size_t,
           :priority, :int,
           :range_subid, :int,
           :securityStateRef, :pointer
    )

  end
 # puts "snmppdu size = #{SnmpPdu.size}"
  callback(:snmp_callback, [ :int, :pointer, :int, :pointer, :pointer ], :int)
  callback(:netsnmp_callback, [ :int, :pointer, :int, :pointer, :pointer ], :int)
  class SnmpSession < NiceFFI::Struct
    layout(
           :version, :long,
           :retries, :int,
           :timeout, :long,
           :flags, :u_long,
           :subsession, :pointer,
           :next, :pointer,
           :peername, :pointer,
           :remote_port, :u_short,
           :localname, :pointer,
           :local_port, :u_short,
           :authenticator, callback([ :pointer, :pointer, :pointer, :uint ], :pointer),
           :callback, :netsnmp_callback,
           :callback_magic, :pointer,
           :s_errno, :int,
           :s_snmp_errno, :int,
           :sessid, :long,
           :community, :pointer,
           :community_len, :size_t,
           :rcvMsgMaxSize, :size_t,
           :sndMsgMaxSize, :size_t,
           :isAuthoritative, :u_char,
           :contextEngineID, :pointer,
           :contextEngineIDLen, :size_t,
           :engineBoots, :u_int,
           :engineTime, :u_int,
           :contextName, :pointer,
           :contextNameLen, :size_t,
           :securityEngineID, :pointer,
           :securityEngineIDLen, :size_t,
           :securityName, :pointer,
           :securityNameLen, :size_t,
           :securityAuthProto, :pointer,
           :securityAuthProtoLen, :size_t,
           :securityAuthKey, [:u_char, 32],
           :securityAuthKeyLen, :size_t,
           :securityAuthLocalKey, :pointer,
           :securityAuthLocalKeyLen, :size_t,
           :securityPrivProto, :pointer,
           :securityPrivProtoLen, :size_t,
           :securityPrivKey, [:u_char, 32],
           :securityPrivKeyLen, :size_t,
           :securityPrivLocalKey, :pointer,
           :securityPrivLocalKeyLen, :size_t,
           :securityModel, :int,
           :securityLevel, :int,
           :paramName, :pointer,
           :securityInfo, :pointer,
           :myvoid, :pointer
    )
  end
  class Tree < NiceFFI::Struct
    layout(
      :child_list, :pointer,
      :next_peer, :pointer,
      :next, :pointer,
      :parent, :pointer,
      :label, :string,
      :subid, :u_long,
      :modid, :int,
      :number_modules, :int,
      :module_list, :pointer,
      :tc_index, :int,
      :type, :int,
      :access, :int,
      :status, :int,
      :enums, :pointer,
      :ranges, :pointer,
      :indexes, :pointer,
      :augments, :pointer,
      :varbinds, :pointer,
      :hint, :pointer,
      :units, :pointer,
      :printomat, callback([:pointer, :pointer, :pointer, :int, :pointer, :pointer, :pointer, :pointer], :int),
      :printer, callback([:pointer, :pointer, :pointer, :pointer, :pointer], :void),
      :description, :pointer,
      :reference, :pointer,
      :reported, :int,
      :defaultValue, :pointer
    )
      # struct tree    *child_list;     /* list of children of this node */
      # struct tree    *next_peer;      /* Next node in list of peers */
      # struct tree    *next;   /* Next node in hashed list of names */
      # struct tree    *parent;
      # char           *label;  /* This node's textual name */
      # u_long          subid;  /* This node's integer subidentifier */
      # int             modid;  /* The module containing this node */
      # int             number_modules;
      # int            *module_list;    /* To handle multiple modules */
      # int             tc_index;       /* index into tclist (-1 if NA) */
      # int             type;   /* This node's object type */
      # int             access; /* This nodes access */
      # int             status; /* This nodes status */
      # struct enum_list *enums;        /* (optional) list of enumerated integers */
      # struct range_list *ranges;
      # struct index_list *indexes;
      # char           *augments;
      # struct varbind_list *varbinds;
      # char           *hint;
      # char           *units;
      # int             (*printomat) (u_char **, size_t *, size_t *, int,
      #                               const netsnmp_variable_list *,
      #                               const struct enum_list *, const char *,
      #                               const char *);
      # void            (*printer) (char *, const netsnmp_variable_list *, const struct enum_list *, const char *, const char *);   /* Value printing function */
      # char           *description;    /* description (a quoted string) */
      # char           *reference;    /* references (a quoted string) */
      # int             reported;       /* 1=report started in print_subtree... */
      # char           *defaultValue;
  end
  attach_function :init_mib, [], :void
  attach_function :read_all_mibs, [], :void
  attach_function :get_tree_head, [], Tree.typed_pointer
  attach_function :get_tree, [:pointer, :int, :pointer], Tree.typed_pointer


#  puts "snmp_session size = #{SnmpSession.size}"
  attach_function :snmp_open, [ :pointer ], SnmpSession.typed_pointer
  attach_function :snmp_errstring, [:int], :string
  attach_function :snmp_close, [ :pointer ], :int
  attach_function :snmp_close_sessions, [  ], :int
  attach_function :snmp_send, [ :pointer, :pointer ], :int
  attach_function :snmp_async_send, [ :pointer, :pointer, :netsnmp_callback, :pointer ], :int
  attach_function :snmp_read, [ :pointer ], :void
  attach_function :snmp_free_pdu, [ :pointer ], :void
  attach_function :snmp_free_var, [ :pointer ], :void
  attach_function :snmp_free_varbind, [ :pointer ], :void
  attach_function :snmp_select_info, [ :pointer, :pointer, :pointer, :pointer ], :int
  attach_function :snmp_timeout, [  ], :void

  attach_function :snmp_get_next_msgid, [  ], :long
  attach_function :snmp_get_next_reqid, [  ], :long
  attach_function :snmp_get_next_sessid, [  ], :long
  attach_function :snmp_get_next_transid, [  ], :long
  attach_function :snmp_oid_compare, [ :pointer, :uint, :pointer, :uint ], :int
  attach_function :snmp_oid_ncompare, [ :pointer, :uint, :pointer, :uint, :uint ], :int
  attach_function :snmp_oidtree_compare, [ :pointer, :uint, :pointer, :uint ], :int
  attach_function :snmp_oidsubtree_compare, [ :pointer, :uint, :pointer, :uint ], :int
  attach_function :netsnmp_oid_compare_ll, [ :pointer, :uint, :pointer, :uint, :pointer ], :int
  attach_function :netsnmp_oid_equals, [ :pointer, :uint, :pointer, :uint ], :int
#  attach_function :netsnmp_oid_tree_equals, [ :pointer, :uint, :pointer, :uint ], :int
  attach_function :netsnmp_oid_is_subtree, [ :pointer, :uint, :pointer, :uint ], :int
  attach_function :netsnmp_oid_find_prefix, [ :pointer, :uint, :pointer, :uint ], :int
  attach_function :init_snmp, [ :string ], :void
  attach_function :snmp_pdu_build, [ :pointer, :pointer, :pointer ], :pointer
  attach_function :snmpv3_parse, [ :pointer, :pointer, :pointer, :pointer, :pointer ], :int
  attach_function :snmpv3_packet_build, [ :pointer, :pointer, :pointer, :pointer, :pointer, :uint ], :int
#  attach_function :snmpv3_packet_rbuild, [ :pointer, :pointer, :pointer, :pointer, :pointer, :uint ], :int
  attach_function :snmpv3_make_report, [ :pointer, :int ], :int
  attach_function :snmpv3_get_report_type, [ :pointer ], :int
  attach_function :snmp_pdu_parse, [ :pointer, :pointer, :pointer ], :int
  attach_function :snmpv3_scopedPDU_parse, [ :pointer, :pointer, :pointer ], :pointer
  attach_function :snmp_store, [ :string ], :void
  attach_function :snmp_shutdown, [ :string ], :void
  attach_function :snmp_pdu_add_variable, [ :pointer, :pointer, :uint, :u_char, :pointer, :size_t ], :pointer
  attach_function :snmp_varlist_add_variable, [ :pointer, :pointer, :uint, :u_char, :pointer, :uint ], :pointer
  attach_function :snmp_add_var, [ :pointer, :pointer, :uint, :char, :string ], :int
  attach_function :snmp_duplicate_objid, [ :pointer, :uint ], :pointer
  attach_function :snmp_increment_statistic, [ :int ], :u_int
  attach_function :snmp_increment_statistic_by, [ :int, :int ], :u_int
  attach_function :snmp_get_statistic, [ :int ], :u_int
  attach_function :snmp_init_statistics, [  ], :void
  attach_function :create_user_from_session, [ :pointer ], :int
 # attach_function :snmp_get_fd_for_session, [ :pointer ], :int
  attach_function :snmp_open_ex, [ :pointer, callback([ :pointer, :pointer, :pointer, :int ], :int), callback([ :pointer, :pointer, :pointer, :uint ], :int), callback([ :pointer, :pointer, :int ], :int), callback([ :pointer, :pointer, :pointer, :pointer ], :int), callback([ :pointer, :pointer, :pointer, :pointer, :pointer ], :int), callback([ :pointer, :uint ], :int) ], :pointer
  attach_function :snmp_set_do_debugging, [ :int ], :void
  attach_function :snmp_get_do_debugging, [  ], :int
  attach_function :snmp_error, [ :pointer, :pointer, :pointer, :pointer ], :void
  attach_function :snmp_sess_init, [ :pointer ], :void
  attach_function :snmp_sess_open, [ :pointer ], :pointer
  attach_function :snmp_sess_pointer, [ :pointer ], :pointer
  attach_function :snmp_sess_session, [ :pointer ], :pointer
  attach_function :snmp_sess_transport, [ :pointer ], :pointer
  attach_function :snmp_sess_transport_set, [ :pointer, :pointer ], :void
  attach_function :snmp_sess_add_ex, [ :pointer, :pointer, callback([ :pointer, :pointer, :pointer, :int ], :int), callback([ :pointer, :pointer, :pointer, :uint ], :int), callback([ :pointer, :pointer, :int ], :int), callback([ :pointer, :pointer, :pointer, :pointer ], :int), callback([ :pointer, :pointer, :pointer, :pointer, :pointer ], :int), callback([ :pointer, :uint ], :int), callback([ :pointer, :pointer, :uint ], :pointer) ], :pointer
  attach_function :snmp_sess_add, [ :pointer, :pointer, callback([ :pointer, :pointer, :pointer, :int ], :int), callback([ :pointer, :pointer, :int ], :int) ], :pointer
  attach_function :snmp_add, [ :pointer, :pointer, callback([ :pointer, :pointer, :pointer, :int ], :int), callback([ :pointer, :pointer, :int ], :int) ], :pointer
  attach_function :snmp_add_full, [ :pointer, :pointer, callback([ :pointer, :pointer, :pointer, :int ], :int), callback([ :pointer, :pointer, :pointer, :uint ], :int), callback([ :pointer, :pointer, :int ], :int), callback([ :pointer, :pointer, :pointer, :pointer ], :int), callback([ :pointer, :pointer, :pointer, :pointer, :pointer ], :int), callback([ :pointer, :uint ], :int), callback([ :pointer, :pointer, :uint ], :pointer) ], :pointer
  attach_function :snmp_sess_send, [ :pointer, :pointer ], :int
  attach_function :snmp_sess_async_send, [ :pointer, :pointer, :netsnmp_callback, :pointer ], :int
  attach_function :snmp_sess_select_info, [ :pointer, :pointer, :pointer, :pointer, :pointer ], :int
  attach_function :snmp_sess_read, [ :pointer, :pointer ], :int
  attach_function :snmp_sess_timeout, [ :pointer ], :void
  attach_function :snmp_sess_close, [ :pointer ], :int
  attach_function :snmp_sess_error, [ :pointer, :pointer, :pointer, :pointer ], :void
  attach_function :netsnmp_sess_log_error, [ :int, :string, :pointer ], :void
  attach_function :snmp_sess_perror, [ :string, :pointer ], :void
  attach_function :snmp_pdu_type, [ :int ], :string


  
  attach_function :asn_check_packet, [ :pointer, :uint ], :int
  attach_function :asn_parse_int, [ :pointer, :pointer, :pointer, :pointer, :uint ], :pointer
  attach_function :asn_build_int, [ :pointer, :pointer, :u_char, :pointer, :uint ], :pointer
  attach_function :asn_parse_unsigned_int, [ :pointer, :pointer, :pointer, :pointer, :uint ], :pointer
  attach_function :asn_build_unsigned_int, [ :pointer, :pointer, :u_char, :pointer, :uint ], :pointer
  attach_function :asn_parse_string, [ :pointer, :pointer, :pointer, :pointer, :pointer ], :pointer
  attach_function :asn_build_string, [ :pointer, :pointer, :u_char, :pointer, :uint ], :pointer
  attach_function :asn_parse_header, [ :pointer, :pointer, :pointer ], :pointer
  attach_function :asn_parse_sequence, [ :pointer, :pointer, :pointer, :u_char, :string ], :pointer
  attach_function :asn_build_header, [ :pointer, :pointer, :u_char, :uint ], :pointer
  attach_function :asn_build_sequence, [ :pointer, :pointer, :u_char, :uint ], :pointer
  attach_function :asn_parse_length, [ :pointer, :pointer ], :pointer
  attach_function :asn_build_length, [ :pointer, :pointer, :uint ], :pointer
  attach_function :asn_parse_objid, [ :pointer, :pointer, :pointer, :pointer, :pointer ], :pointer
  attach_function :asn_build_objid, [ :pointer, :pointer, :u_char, :pointer, :uint ], :pointer
  attach_function :asn_parse_null, [ :pointer, :pointer, :pointer ], :pointer
  attach_function :asn_build_null, [ :pointer, :pointer, :u_char ], :pointer
  attach_function :asn_parse_bitstring, [ :pointer, :pointer, :pointer, :pointer, :pointer ], :pointer
  attach_function :asn_build_bitstring, [ :pointer, :pointer, :u_char, :pointer, :uint ], :pointer
  attach_function :asn_parse_unsigned_int64, [ :pointer, :pointer, :pointer, :pointer, :uint ], :pointer
  attach_function :asn_build_unsigned_int64, [ :pointer, :pointer, :u_char, :pointer, :uint ], :pointer
  attach_function :asn_parse_signed_int64, [ :pointer, :pointer, :pointer, :pointer, :uint ], :pointer
  attach_function :asn_build_signed_int64, [ :pointer, :pointer, :u_char, :pointer, :uint ], :pointer
  attach_function :asn_build_float, [ :pointer, :pointer, :u_char, :pointer, :uint ], :pointer
  attach_function :asn_parse_float, [ :pointer, :pointer, :pointer, :pointer, :uint ], :pointer
  attach_function :asn_build_double, [ :pointer, :pointer, :u_char, :pointer, :uint ], :pointer
  attach_function :asn_parse_double, [ :pointer, :pointer, :pointer, :pointer, :uint ], :pointer

  attach_function :snmp_pdu_create, [:int], SnmpPdu.typed_pointer
  attach_function :get_node, [:pointer, :pointer, :pointer], :int
  attach_function :snmp_add_null_var, [:pointer, :pointer, :size_t], :pointer
  attach_function :snmp_synch_response, [:pointer, :pointer, :pointer], :int
  attach_function :snmp_parse_oid, [:string, :pointer, :pointer], :pointer
  attach_function :snmp_api_errstring, [ :int ], :string
  attach_function :snmp_perror, [ :string ], :void
  attach_function :snmp_set_detail, [ :string ], :void
  
  attach_function :snmp_select_info, [:pointer, :pointer, :pointer, :pointer], :int
  attach_function :select, [:int, :pointer, :pointer, :pointer, :pointer], :int
  attach_function :snmp_read, [:pointer], :void
  def self.get_fd_set
    FFI::MemoryPointer.new(:pointer, 128)
  end
end
end
end
