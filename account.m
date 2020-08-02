classdef account

properties
  institution
  id
  totalValue
  unrealValue
  realValue
  date
  name
  type
end %properties

methods
  function [obj] = account()
    obj.institution = 'NONE';
    obj.id          = -999;
    obj.totalValue  = -999;
    obj.unrealValue = -999;
    obj.realValue   = -999;
    obj.date        = -999;
    obj.name        = 'NONE';
    obj.type        = 'NONE';
  end
  
  function [obj] = edit(obj,institution,id,unrealValue,realValue,date,name,type)
    obj = obj.setInstitution(institution);
    obj = obj.setId(id);
    obj = obj.setUnrealValue(unrealValue);
    obj = obj.setRealValue(realValue);
    obj = obj.setTotalValue();
    obj = obj.setDate(date);
    obj = obj.setName(name);
    obj = obj.setType(type);
  end
end %methods 

methods (Access = private)
  function [obj] = setInstitution(obj,institution)
    obj.institution = institution;
  end
  
  function [obj] = setId(obj,id)
    obj.id = id;
  end

  function [obj] = setUnrealValue(obj,unrealValue)
    obj.unrealValue = unrealValue;
  end
  
  function [obj] = setRealValue(obj,realValue)
    obj.realValue = realValue;
  end
  
  function [obj] = setTotalValue(obj)
    obj.totalValue = obj.realValue + obj.unrealValue;
  end
  
  function [obj] = setDate(obj,date)
    obj.date = date;
  end
  
  function [obj] = setName(obj,name)
    obj.name = name;
  end
  
  function [obj] = setType(obj,type)
    obj.type = type;
  end
end %methods (Access = private)

end %classdef
