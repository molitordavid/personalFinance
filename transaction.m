classdef transaction

properties
  isExpense
  isReal
  value
  merchant
  name
  type
  date
  assAcc
  assAccId
  note
  id
end %properties

methods
  function [obj] = transaction()
    obj.isExpense = true;
    obj.value     = -999;
    obj.merchant  = 'NONE';
    obj.name      = 'NONE';
    obj.type      = 'NONE';
    obj.date      = -999;
    obj.assAcc    = 'NONE';
    obj.assAccId  = -999;
    obj.note      = 'NONE';
    obj.id        = -999;
  end
  
  function [obj] = edit(obj,isExpense,isReal,value,merchant,name,type,date,assAcc,assAccId,note,id)
    obj = obj.setIsExpense(isExpense);
    obj = obj.setIsReal(isReal);
    obj = obj.setValue(value);
    obj = obj.setMerchant(merchant);
    obj = obj.setName(name);
    obj = obj.setType(type);
    obj = obj.setDate(date);
    obj = obj.setAssAcc(assAcc);
    obj = obj.setAssAccId(assAccId);
    obj = obj.setNote(note);
    obj = obj.setId(id);
  end
end %methods 

methods (Access = private)
  function [obj] = setIsExpense(obj,isExpense)
    obj.isExpense = isExpense;
  end
  
  function [obj] = setIsReal(obj,isReal)
    obj.isReal = isReal;
  end
  
  function [obj] = setValue(obj,value)
    obj.value = value;
  end
  
  function [obj] = setMerchant(obj,merchant)
    obj.merchant = merchant;
  end
  
  function [obj] = setName(obj,name)
    obj.name = name;
  end

  function [obj] = setType(obj,type)
    obj.type = type;
  end
  
  function [obj] = setDate(obj,date)
    obj.date = date;
  end
  
  function [obj] = setAssAcc(obj,assAcc)
    obj.assAcc = assAcc;
  end
  
  function [obj] = setAssAccId(obj,assAccId)
    obj.assAccId = assAccId;
  end
  
  function [obj] = setNote(obj,note)
    obj.note = note;
  end
  
  function [obj] = setId(obj,id)
    obj.id = id;
  end
end %methods (Access = private)

end %classdef
