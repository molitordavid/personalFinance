classdef transfer

properties
  value
  fromAcc
  fromAccId
  toAcc
  toAccId
  date
  note
  id
end %properties

methods
  function [obj] = transfer()
    obj.value = -999;
    obj.fromAcc = 'NONE';
    obj.fromAccId = -999;
    obj.toAcc = 'NONE';
    obj.toAccId = -999;
    obj.date = -999;
    obj.note = 'NONE';
    obj.id = -999;
  end
  
  function [obj] = edit(obj,value,fromAcc,fromAccId,toAcc,toAccId,date,note,id)
    obj = obj.setValue(value);
    obj = obj.setFromAcc(fromAcc);
    obj = obj.setFromAccId(fromAccId);
    obj = obj.setToAcc(toAcc);
    obj = obj.setToAccId(toAccId);
    obj = obj.setDate(date);
    obj = obj.setNote(note);
    obj = obj.setId(id);
  end
end %methods 

methods (Access = private)
  function [obj] = setValue(obj,value)
    obj.value = value;
  end
  
  function [obj] = setFromAcc(obj,fromAcc)
    obj.fromAcc = fromAcc;
  end

  function [obj] = setFromAccId(obj,fromAccId)
    obj.fromAccId = fromAccId;
  end
  
  function [obj] = setToAcc(obj,toAcc)
    obj.toAcc = toAcc;
  end
  
  function [obj] = setToAccId(obj,toAccId)
    obj.toAccId = toAccId;
  end
  
  function [obj] = setDate(obj,date)
    obj.date = date;
  end
  
  function [obj] = setNote(obj,note)
    obj.note = note;
  end
  
  function [obj] = setId(obj,id)
    obj.id = id;
  end
end %methods (Access = private)

end %classdef
