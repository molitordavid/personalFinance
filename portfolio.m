classdef portfolio

properties
  transactionList
  accountList
  accountHistList
  transferList
  nTransaction
  nTransfer
  nAccount
end %properties

methods
  function [obj] = portfolio()
    obj.transactionList = [];
    obj.accountList = account();
    obj.accountHistList.history = [];
    obj.transferList = transfer();
    obj.transactionList = transaction();
    obj.nTransaction = 0;
    obj.nTransfer = 0;
    obj.nAccount = 0;
  end
  
  function [obj] = addTransaction(obj,isExpense,isReal,value,merchant,name,type,assAcc,note)
    date = datevec(now);
    assAccId = find([strcmpi(assAcc,{obj.accountList(:).name})]);
    if isempty(assAccId)
      error('portflio.addTransaction: associated account of name %s does not exist',assAcc);
    end
    transactionID = obj.nTransaction + 1;
    TA = transaction();
    TA = TA.edit(isExpense,isReal,value,merchant,name,type,date,assAcc,assAccId,note,transactionID);
    obj.transactionList(transactionID) = TA;
    obj = obj.executeTransaction(TA,value);
    obj.nTransaction = obj.nTransaction + 1;
  end
  
  function [obj] = addAccount(obj,institution,unrealValue,realValue,name,type)
    date = datevec(now);
      if any([strcmpi(name,{obj.accountList(:).name})])
        error('portfolio.addAccount: Cannot add account of name %s becuase it already exists',name);
      end
    accountId = obj.nAccount + 1;
    AC = account();
    AC = AC.edit(institution,accountId,unrealValue,realValue,date,name,type);
    obj.accountList(accountId) = AC;
    obj.accountHistList(accountId).history = AC;
    obj.nAccount = obj.nAccount + 1;
  end
  
  function [obj] = addTransfer(obj,value,fromAcc,toAcc,note)
    date = datevec(now);
    fromAccId = find([strcmpi(fromAcc,{obj.accountList(:).name})]);
    toAccId = find([strcmpi(toAcc,{obj.accountList(:).name})]);
    if isempty(fromAccId) || isempty(toAccId)
      error('portflio.addTransfer: associated account(s) of name(s) %s, %s may not exist',fromAcc,toAcc);
    end
    transferId = obj.nTransfer + 1;
    TR = transfer();
    TR = TR.edit(value,fromAcc,fromAccId,toAcc,toAccId,date,note,transferId);
    obj.transferList(transferId) = TR;
    obj = obj.executeTransfer(TR,value);
    obj.nTransfer = obj.nTransfer + 1;
  end
end %methods 

methods (Access = private)
  function [obj] = executeTransaction(obj,TA,valueDelta)
    AC = obj.accountList(TA.assAccId);
    if TA.isExpense
        if TA.isReal
            newRealValue = AC.realValue - valueDelta;
            newUnrealValue = AC.unrealValue;
        else
            newUnrealValue = AC.unrealValue - valueDelta;
            newRealValue = AC.realValue;
        end
    else
        if TA.isReal
            newRealValue = AC.realValue + valueDelta;
            newUnrealValue = AC.unrealValue;
        else
            newUnrealValue = AC.unrealValue + valueDelta;
            newRealValue = AC.realValue;
        end
    end
    AC = AC.edit(AC.institution,AC.id,newUnrealValue,newRealValue,TA.date,AC.name,AC.type);
    obj.accountList(TA.assAccId) = AC;
    obj.accountHistList(TA.assAccId).history(end+1) = AC;
  end

  function [obj] = executeTransfer(obj,TR,valueDelta)
    toAC = obj.accountList(TR.toAccId);
    fromAC = obj.accountList(TR.fromAccId);
    newToAccRealValue = toAC.realValue + valueDelta;
    newFromAccRealValue = fromAC.realValue - valueDelta;
    toAC = toAC.edit(toAC.institution,toAC.id,toAC.unrealValue,newToAccRealValue,TR.date,toAC.name,toAC.type);
    fromAC = fromAC.edit(fromAC.institution,fromAC.id,fromAC.unrealValue,newFromAccRealValue,TR.date,fromAC.name,fromAC.type);
    obj.accountList(TR.toAccId) = toAC;
    obj.accountList(TR.fromAccId) = fromAC;
    obj.accountHistList(TR.toAccId).history(end+1) = toAC;
    obj.accountHistList(TR.fromAccId).history(end+1) = fromAC;
  end
end %methods (Access = private)

end %classdef
