classdef portview
    
    properties
        Figure = [];
        Button = [];
        Element = [];
        Portfolio = [];
        fullFilePath = '';
        validTransactionType = {'Giving','Saving','Food','Utilities','Housing','Transportation','Health','Insurance','Recreation','Personal','Misc','Income','Asset Value'};
        plotString = {'ko-','bs-','r+-','gd-','m^-','cx-','yh-','k+-','bv-','r<-','g>-','mp-','c*-','y|-'};
        maxAccount = []
    end
    
    methods
        function [obj] = portview()
            obj = obj.initSplash;
            obj.maxAccount = numel(obj.plotString);
            setappdata(obj.Figure.splash,'obj',obj);
        end
        
        function [obj] = initSplash(obj)
            obj.Figure.splash = figure('Name','PortView','MenuBar','None','NumberTitle','off','Color',[1 1 1]);
            obj.Figure.splash.Position = [500 500 300 300];  
            obj.Element.splash.title = annotation('textbox', [0, 0.5, 1, 0.5], 'string', 'Portfolio Viewer');
            obj.Element.splash.title.FontSize = 30;
            obj.Element.splash.title.LineStyle = 'none';
            obj.Element.splash.title.HorizontalAlignment = 'center';
   
            obj.Button.Splash.new  = uicontrol(obj.Figure.splash,'Style','pushbutton',...
               'Position',[50, 50, 100, 100],...
               'BackgroundColor',[1 1 1],...  
               'String','Create Portfolio');
               obj.Button.Splash.new.Callback = @obj.createPortfolio;
           
            obj.Button.Splash.load  = uicontrol(obj.Figure.splash,'Style','pushbutton',...
               'Position',[150, 50, 100, 100],...
               'BackgroundColor',[1 1 1],...  
               'String','Load Portfolio');
            obj.Button.Splash.load.Callback = @obj.loadPortfolio;
        end
        
        function [obj] = initHome(obj)
            obj.Figure.home = figure('Name','PortView','MenuBar','None','NumberTitle','off','Color',[1 1 1]);
            obj.Figure.home.Position = [500 200 800 600];
            
            obj.Element.Home.tabGroup = uitabgroup(obj.Figure.home,'Position',[0.2 0.1 0.7 0.7],'TabLocation','left');
            setappdata(obj.Figure.home,'obj',obj);
            obj.Element.Home.tabSummaryPlot= obj.initTabSummaryPlot;
            obj = getappdata(obj.Figure.home,'obj');
            setappdata(obj.Figure.home,'obj',obj);
            obj.Element.Home.tabSummaryTable = obj.initTabSummaryTable;
            obj = getappdata(obj.Figure.home,'obj');
            if obj.Portfolio.nAccount ~= 0
                for iAccount = 1:obj.Portfolio.nAccount
                    setappdata(obj.Figure.home,'obj',obj);
                    obj.Element.Home.tabAccountPlot(iAccount)  = obj.initTabAccountPlot(iAccount);
                    obj = getappdata(obj.Figure.home,'obj');
                    setappdata(obj.Figure.home,'obj',obj);
                    obj.Element.Home.tabAccountTable(iAccount) = obj.initTabAccountTable(iAccount);
                    obj = getappdata(obj.Figure.home,'obj');
                end
            end
            
            obj.Button.Home.save  = uicontrol(obj.Figure.home,'Style','pushbutton',...
               'Position',[10, 550, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Save Portfolio');
            obj.Button.Home.save.Callback = @obj.savePortfolio;
               
            obj.Button.Home.addAccount = uicontrol(obj.Figure.home,'Style','pushbutton',...
               'Position',[10, 450, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Add Account');
            obj.Button.Home.addAccount.Callback = @obj.addAccount;
               
            obj.Button.Home.addTransfer = uicontrol(obj.Figure.home,'Style','pushbutton',...
               'Position',[10, 350, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Add Transfer');
            obj.Button.Home.addTransfer.Callback = @obj.addTransfer;
               
            obj.Button.Home.addTransaction = uicontrol(obj.Figure.home,'Style','pushbutton',...
               'Position',[10, 250, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Add Transaction');
            obj.Button.Home.addTransaction.Callback = @obj.addTransaction;  
        end   
        
        function [obj] = initAccount(obj)
            obj.Figure.account = figure('Name','Add Account','MenuBar','None','NumberTitle','off','Color',[1 1 1]);
            obj.Figure.account.Position = [500 200 800 600];
            
            obj.Button.Account.add  = uicontrol(obj.Figure.account,'Style','pushbutton',...
               'Position',[10, 550, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Add Account');
           
           obj.Button.Account.cancel = uicontrol(obj.Figure.account,'Style','pushbutton',...
               'Position',[10, 475, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Cancel'); 
           
           obj.Element.Account.table = uitable(obj.Figure.account,...
               'Position',[160, 250, 600, 300],...
               'ColumnName', 'New Account Data',...
               'RowName',{'Institution','Unrealized Value','Realized Value','Name','Type'},...
               'ColumnEditable',true);
            obj.Element.Account.table.Data = {'Institution Name';'0';'0';'Account Name';'Account Type'};
            obj.Element.Account.table.CellEditCallback = @obj.checkAccountTable;
            obj.Button.Account.add.Callback = @obj.executeAddAccount;
            obj.Button.Account.cancel.Callback = @obj.cancelAccount;
        end
        
        function [obj] = initTransfer(obj)
            obj.Figure.transfer = figure('Name','Add Transfer','MenuBar','None','NumberTitle','off','Color',[1 1 1]);
            obj.Figure.transfer.Position = [500 200 800 600];
            
            obj.Button.Transfer.add  = uicontrol(obj.Figure.transfer,'Style','pushbutton',...
               'Position',[10, 550, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Add Transfer');
                      
           obj.Button.Transfer.cancel = uicontrol(obj.Figure.transfer,'Style','pushbutton',...
               'Position',[10, 475, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Cancel'); 
           
            obj.Element.Transfer.table = uitable(obj.Figure.transfer,...
               'Position',[160, 250, 600, 300],...
               'ColumnName', 'Transfer Data',...
               'RowName',{'Transfer Value','From Account Name','To Account Name','Notes'},...
               'ColumnEditable',true);
            obj.Element.Transfer.table.Data = {'0';'Account Name';'Account Name';'Transfer Note'};
            obj.Element.Transfer.table.CellEditCallback = @obj.checkTransferTable;
            obj.Button.Transfer.add.Callback = @obj.executeAddTransfer;
            obj.Button.Transfer.cancel.Callback = @obj.cancelTransfer;
        end
        
        function [obj] = initTransaction(obj)
            obj.Figure.transaction = figure('Name','Add Transaction','MenuBar','None','NumberTitle','off','Color',[1 1 1]);
            obj.Figure.transaction.Position = [500 200 800 600];
            
            obj.Button.Transaction.add  = uicontrol(obj.Figure.transaction,'Style','pushbutton',...
               'Position',[10, 550, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Add Transaction');
           
            obj.Button.Transaction.cancel = uicontrol(obj.Figure.transaction,'Style','pushbutton',...
               'Position',[10, 475, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Cancel'); 
           
            obj.Element.Transaction.isExpense = uicontrol(obj.Figure.transaction,'Style','Checkbox',...
                'Position',[10, 350, 200, 50],...
                'BackgroundColor',[1 1 1],...
                'String','Is this an expense?');
            
            obj.Element.Transaction.isReal = uicontrol(obj.Figure.transaction,'Style','Checkbox',...
                'Position',[10, 250, 200, 50],...
                'BackgroundColor',[1 1 1],...
                'String','Is this realized value?');
            
            obj.Element.Transaction.table = uitable(obj.Figure.transaction,...
               'Position',[160, 250, 600, 300],...
               'ColumnName', 'Transaction Data',...
               'RowName',{'Value','Merchant','Name','Type','Account Name','Notes'},...
               'ColumnEditable',true);
            obj.Element.Transaction.table.Data = {'0';'Merchant Name';'Transaction Name';'Transaction Type';'Transaction Account Name';'Transaction Note'};
            obj.Element.Transaction.isExpense.Callback = @obj.setIsExpense;
            obj.Element.Transaction.isExpenseBool = false;
            obj.Element.Transaction.isReal.Callback = @obj.setIsReal;
            obj.Element.Transaction.isRealBool = false;
            obj.Element.Transaction.table.CellEditCallback = @obj.checkTransactionTable;
            obj.Button.Transaction.add.Callback = @obj.executeAddTransaction;
            obj.Button.Transaction.cancel.Callback = @obj.cancelTransaction;
        end
    end
    
    methods (Access = private)
        function loadPortfolio(obj,~,~)
            obj = getappdata(obj.Figure.splash,'obj');
            obj.fullFilePath
            [file,path] = uigetfile('..\*.mat','Select a PortView .mat File');
            if file~=0
                obj.fullFilePath = fullfile(path,file);
                dummyVar = load(obj.fullFilePath);
                obj.Portfolio = dummyVar.obj.Portfolio;
                set(obj.Figure.splash, 'Visible', 'off');
                obj = obj.initHome();
                setappdata(obj.Figure.home,'obj',obj);
            else
                obj.fullFilePath = '';
            end
            setappdata(obj.Figure.splash,'obj',obj);
        end
            
        function createPortfolio(obj,~,~)
            obj = getappdata(obj.Figure.splash,'obj');
            obj.Portfolio = portfolio;
            set(obj.Figure.splash, 'Visible', 'off');
            obj = obj.initHome();
            setappdata(obj.Figure.home,'obj',obj);
            setappdata(obj.Figure.splash,'obj',obj);
        end
        
        function savePortfolio(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            [file,path] = uiputfile('*.mat','Save a PortView .mat file','PortViewData.mat');
            if file~=0
                obj.fullFilePath = fullfile(path,file);
                save(obj.fullFilePath,'obj');
            else
                obj.fullFilePath = '';
            end
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function addAccount(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            if obj.Portfolio.nAccount == obj.maxAccount
                errordlg('Cannot add account. Maximum number reached.','Account Error');
                return
            end
            set(obj.Figure.home, 'Visible', 'off');
            obj = obj.initAccount();
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function cancelAccount(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            close(obj.Figure.account)
            obj = obj.initHome;
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function addTransfer(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            set(obj.Figure.home, 'Visible', 'off');
            obj = obj.initTransfer();
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function cancelTransfer(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            close(obj.Figure.transfer)
            obj = obj.initHome;
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function addTransaction(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            set(obj.Figure.home, 'Visible', 'off');
            obj = obj.initTransaction();
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function cancelTransaction(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            close(obj.Figure.transaction)
            obj = obj.initHome;
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function executeAddAccount(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            if ~strcmp(obj.Element.Account.table.Data{1,1},'Institution Name')
                isTableChanged(1) = 1;
            end
            if ~strcmp(obj.Element.Account.table.Data{4,1},'Account Name')
                isTableChanged(2) = 1;
            end
            if ~strcmp(obj.Element.Account.table.Data{5,1},'Account Type')
                isTableChanged(3) = 1;
            end
            if ~any(isTableChanged)
                errordlg('All table fields must be edited','Table Entry Error'); 
                return
            end
            institution = obj.Element.Account.table.Data{1,1};
            unrealValue = str2double(obj.Element.Account.table.Data{2,1});
            realValue = str2double(obj.Element.Account.table.Data{3,1});
            name = obj.Element.Account.table.Data{4,1};
            type = obj.Element.Account.table.Data{5,1};
            obj.Portfolio = obj.Portfolio.addAccount(institution,unrealValue,realValue,name,type);
            close(obj.Figure.account);
            obj = obj.initHome();
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function executeAddTransfer(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            if ~strcmp(obj.Element.Transfer.table.Data{2,1},'Account Name')
                isTableChanged(1) = 1;
            end
            if ~strcmp(obj.Element.Transfer.table.Data{3,1},'Account Name')
                isTableChanged(2) = 1;
            end
            if ~strcmp(obj.Element.Transfer.table.Data{4,1},'Account Note')
                isTableChanged(3) = 1;
            end
            if ~any(isTableChanged)
                errordlg('All table fields must be edited','Table Entry Error'); 
                return
            end
            transferValue = str2double(obj.Element.Transfer.table.Data{1,1});
            toAccount = obj.Element.Transfer.table.Data{2,1};
            fromAccount = obj.Element.Transfer.table.Data{3,1};
            transferNote = obj.Element.Transfer.table.Data{4,1};
            obj.Portfolio = obj.Portfolio.addTransfer(transferValue,toAccount,fromAccount,transferNote);
            close(obj.Figure.transfer);
            obj = obj.initHome();
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function executeAddTransaction(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            if ~strcmp(obj.Element.Transaction.table.Data{2,1},'Merchant Name')
                isTableChanged(1) = 1;
            end
            if ~strcmp(obj.Element.Transaction.table.Data{3,1},'Transaction Name')
                isTableChanged(2) = 1;
            end
            if ~strcmp(obj.Element.Transaction.table.Data{4,1},'Transaction Type')
                isTableChanged(3) = 1;
            end
            if ~strcmp(obj.Element.Transaction.table.Data{4,1},'Transaction Account Name')
                isTableChanged(4) = 1;
            end
            if ~strcmp(obj.Element.Transaction.table.Data{4,1},'Transaction Note')
                isTableChanged(5) = 1;
            end
            if ~any(isTableChanged)
                errordlg('All table fields must be edited','Table Entry Error'); 
                return
            end
            transactionValue = str2double(obj.Element.Transaction.table.Data{1,1});
            merchantName = obj.Element.Transaction.table.Data{2,1};
            transactionName = obj.Element.Transaction.table.Data{3,1};
            transactionType = obj.Element.Transaction.table.Data{4,1};
            accountName = obj.Element.Transaction.table.Data{5,1};
            transactionNote = obj.Element.Transaction.table.Data{6,1};
            isExpense = obj.Element.Transaction.isExpenseBool;
            isReal = obj.Element.Transaction.isRealBool;
            obj.Portfolio = obj.Portfolio.addTransaction(isExpense,isReal,transactionValue,merchantName,transactionName,transactionType,accountName,transactionNote);
            close(obj.Figure.transaction);
            obj = obj.initHome();
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function checkAccountTable(obj,hObject,callbackdata)
            obj = getappdata(obj.Figure.home,'obj');
            if ~isfinite(str2double(callbackdata.Source.Data{2,1}))
                errordlg('Unrealized value must be numeric','Table Entry Error');
                hObject.Data{2,1} = '0';
            end
            if ~isfinite(str2double(callbackdata.Source.Data{3,1}))
                errordlg('Realized value must be numeric','Table Entry Error');
                hObject.Data{3,1} = '0';
            end
            if ~isempty(obj.Portfolio.accountList)
                nAccount = numel(obj.Portfolio.accountList);
                doesNameAlreadyExist = false;
                for iAccount = 1:nAccount
                   if strcmpi(callbackdata.Source.Data{4,1},obj.Portfolio.accountList(iAccount).name)
                       doesNameAlreadyExist = true;
                   end
                end
                if doesNameAlreadyExist
                    errordlg('Account name must be unique','Table Entry Error');
                    hObject.Data{4,1} = 'Account Name';
                end
            end
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function checkTransferTable(obj,hObject,callbackdata)
            obj = getappdata(obj.Figure.home,'obj');
            if ~isfinite(str2double(callbackdata.Source.Data{1,1}))
                errordlg('Transfer value must be numeric','Table Entry Error');
                hObject.Data{1,1} = '0';
            end
            if ~strcmp(callbackdata.Source.Data{2,1},'Account Name') 
                isFromAccountFound = false;
                for iAccount = 1:obj.Portfolio.nAccount
                    if strcmp(callbackdata.Source.Data{2,1},obj.Portfolio.accountList(iAccount).name)
                        isFromAccountFound = true;
                    end
                end
                if ~isFromAccountFound
                    errordlg('From Account not found','Table Entry Error');
                    hObject.Data{2,1} = 'Account Name';
                end 
            end
            if ~strcmp(callbackdata.Source.Data{3,1},'Account Name') 
                isToAccountFound = false;
                for iAccount = 1:obj.Portfolio.nAccount
                    if strcmp(callbackdata.Source.Data{3,1},obj.Portfolio.accountList(iAccount).name)
                        isToAccountFound = true;
                    end
                end
                if ~isToAccountFound
                    errordlg('To Account not found','Table Entry Error');
                    hObject.Data{3,1} = 'Account Name';
                end 
            end
            setappdata(obj.Figure.home,'obj',obj);    
        end
        
        function checkTransactionTable(obj,hObject,callbackdata)
            obj = getappdata(obj.Figure.home,'obj');
            if ~isfinite(str2double(callbackdata.Source.Data{1,1}))
                errordlg('Transaction value must be numeric','Table Entry Error');
                hObject.Data{1,1} = '0';
            end
            if ~strcmp(callbackdata.Source.Data{4,1},'Transaction Type') 
                isTypeValid = false;
                for iType = 1:numel(obj.validTransactionType)
                    if strcmp(callbackdata.Source.Data{4,1},obj.validTransactionType(iType))
                        isTypeValid = true;
                    end
                end
                if ~isTypeValid
                    errordlg('Type not found. Available types are: Giving, Saving, Food, Utilities, Housing, Transportation, Health, Insurance, Recreation, Personal, Misc, Income, Asset Value.','Table Entry Error');
                    hObject.Data{4,1} = 'Transaction Type';
                end 
            end
            if ~strcmp(callbackdata.Source.Data{5,1},'Transaction Account Name') 
                isAccountFound = false;
                for iAccount = 1:obj.Portfolio.nAccount
                    if strcmp(callbackdata.Source.Data{5,1},obj.Portfolio.accountList(iAccount).name)
                        isAccountFound = true;
                    end
                end
                if ~isAccountFound
                    errordlg('Account not found','Table Entry Error');
                    hObject.Data{5,1} = 'Transaction Account Name';
                end 
            end
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function setIsExpense(obj,~,callbackdata)
            obj = getappdata(obj.Figure.home,'obj');
            obj.Element.Transaction.isExpenseBool = logical(callbackdata.Source.Value);
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function setIsReal(obj,~,callbackdata)
            obj = getappdata(obj.Figure.home,'obj');
            obj.Element.Transaction.isRealBool = logical(callbackdata.Source.Value);
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function [tabHandle] = initTabSummaryPlot(obj)
            obj = getappdata(obj.Figure.home,'obj');
            tabHandle = uitab(obj.Element.Home.tabGroup,'title','Portfolio Summary Plot','BackgroundColor',[1,1,1]);
            axesHandle = axes('Parent',tabHandle);
            hold on
            if obj.Portfolio.nAccount == 0
                setappdata(obj.Figure.home,'obj',obj);
                return
            end
            for iAccount = 1:obj.Portfolio.nAccount
                for iAbscissa = 1:length(obj.Portfolio.accountHistList(iAccount).history)
                    abscissa(iAbscissa) = datetime(obj.Portfolio.accountHistList(iAccount).history(iAbscissa).date);
                    ordinate(iAbscissa) = obj.Portfolio.accountHistList(iAccount).history(iAbscissa).totalValue;

                end
                legendStr{iAccount} = obj.Portfolio.accountList(iAccount).name;
                plot(abscissa,ordinate,obj.plotString{iAccount},'Linewidth',3);
                clear('abscissa');
                clear('ordinate');
            end
            xlabel('Time')
            ylabel('Total Value')
            legend(legendStr,'location','best');
            setappdata(obj.Figure.home,'obj',obj);
        end
            
        function [tabHandle] = initTabAccountPlot(obj,iAccount)
            obj = getappdata(obj.Figure.home,'obj');
            tabHandle = uitab(obj.Element.Home.tabGroup,'title',sprintf('%s Plot',obj.Portfolio.accountList(iAccount).name),'BackgroundColor',[1,1,1]);
            axesHandle = axes('Parent',tabHandle);
            hold on
            for iAbscissa = 1:length(obj.Portfolio.accountHistList(iAccount).history)
                abscissa(iAbscissa) = datetime(obj.Portfolio.accountHistList(iAccount).history(iAbscissa).date);
                ordinate(iAbscissa) = obj.Portfolio.accountHistList(iAccount).history(iAbscissa).totalValue;
            end
            plot(abscissa,ordinate,'-bd','LineWidth',3);
            xlabel('Time')
            ylabel('Total Value')
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function [tabHandle] = initTabSummaryTable(obj)
            obj = getappdata(obj.Figure.home,'obj');
            tabHandle = uitab(obj.Element.Home.tabGroup,'title','Potfolio Summary Table','BackgroundColor',[1,1,1]);
            totalUnrealValue = 0;
            totalRealValue = 0;
            totalValue = 0;
            if obj.Portfolio.nAccount > 0
                for iAccount = 1:obj.Portfolio.nAccount
                    totalUnrealValue = totalUnrealValue + obj.Portfolio.accountList(iAccount).unrealValue;
                    totalRealValue = totalRealValue + obj.Portfolio.accountList(iAccount).realValue;
                    totalValue = totalValue + obj.Portfolio.accountList(iAccount).totalValue;
                end
            end
            tableData = {'Number of Accounts',num2str(obj.Portfolio.nAccount);...
                         'Number of Transfers',num2str(obj.Portfolio.nTransfer);...
                         'Number of Transactions',num2str(obj.Portfolio.nTransaction);...
                         'Total Unrealized Value',num2str(totalUnrealValue);...
                         'Total Realized Value',num2str(totalRealValue);...
                         'Total Value',num2str(totalValue)};
                         
                
            tableHandle = uitable('parent',tabHandle,...
                                  'Rowname',[],...
                                  'Units','Normalized',...
                                  'ColumnName',{'Field','Value'},...
                                  'ColumnWidth',{150, 350},...
                                  'ColumnEditable',[false false],...
                                  'columnFormat',{'char'},...
                                  'Position',[0 0 1 1],...
                                  'Data',tableData);
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function [tabHandle] = initTabAccountTable(obj,iAccount)
            obj = getappdata(obj.Figure.home,'obj');
            tabHandle = uitab(obj.Element.Home.tabGroup,'title',sprintf('%s Table',obj.Portfolio.accountList(iAccount).name),'BackgroundColor',[1,1,1]);
                        tableData = {'Name',obj.Portfolio.accountList(iAccount).name;...
                         'Institution',obj.Portfolio.accountList(iAccount).institution;...
                         'Type',obj.Portfolio.accountList(iAccount).type;...
                         'Unrealized Value',num2str(obj.Portfolio.accountList(iAccount).unrealValue);...
                         'Realized Value',num2str(obj.Portfolio.accountList(iAccount).realValue);...
                         'Total Value',num2str(obj.Portfolio.accountList(iAccount).totalValue);...
                         'date',datestr(obj.Portfolio.accountList(iAccount).date);...
                         'ID',num2str(obj.Portfolio.accountList(iAccount).id)};
                         
                
            tableHandle = uitable('parent',tabHandle,...
                                  'Rowname',[],...
                                  'Units','Normalized',...
                                  'ColumnName',{'Field','Value'},...
                                  'ColumnWidth',{150, 350},...
                                  'ColumnEditable',[false false],...
                                  'columnFormat',{'char'},...
                                  'Position',[0 0 1 1],...
                                  'Data',tableData);
            setappdata(obj.Figure.home,'obj',obj);
        end
    end
end