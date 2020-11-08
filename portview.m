classdef portview
    
    properties
        Figure = [];
        Button = [];
        Element = [];
        Portfolio = [];
        fullFilePath = '';
    end
    
    methods
        function [obj] = portview()
            obj = obj.initSplash;
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
        
        function [obj] = makeHome(obj)
            obj.Figure.home = figure('Name','PortView','MenuBar','None','NumberTitle','off','Color',[1 1 1]);
            obj.Figure.home.Position = [500 200 800 600];
            
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
            obj.Button.Account.add.Callback = @obj.executeAddAccount;
        end
        
        function [obj] = initTransfer(obj)
            obj.Figure.transfer = figure('Name','Add Transfer','MenuBar','None','NumberTitle','off','Color',[1 1 1]);
            obj.Figure.transfer.Position = [500 200 800 600];
            
            obj.Button.Transfer.add  = uicontrol(obj.Figure.transfer,'Style','pushbutton',...
               'Position',[10, 550, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Add Transfer');
           
            %obj.Element.Transfer.title = 
            obj.Button.Transfer.add.Callback = @obj.executeAddTransfer;
        end
        
        function [obj] = initTransaction(obj)
            obj.Figure.transaction = figure('Name','Add Transaction','MenuBar','None','NumberTitle','off','Color',[1 1 1]);
            obj.Figure.transaction.Position = [500 200 800 600];
            
            obj.Button.Transaction.add  = uicontrol(obj.Figure.transaction,'Style','pushbutton',...
               'Position',[10, 550, 100, 50],...
               'BackgroundColor',[1 1 1],...  
               'String','Add Transaction');
            obj.Button.Transaction.add.Callback = @obj.executeAddTransaction;
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
                obj = obj.makeHome();
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
            obj = obj.makeHome();
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
                obj.fullFilepath = '';
            end
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function addAccount(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            set(obj.Figure.home, 'Visible', 'off');
            obj = obj.initAccount();
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function addTransfer(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            set(obj.Figure.home, 'Visible', 'off');
            obj = obj.initTransfer();
            setappdata(obj.Figure.home,'obj',obj);
        end
        
        function addTransaction(obj,~,~)
            obj = getappdata(obj.Figure.home,'obj');
            set(obj.Figure.home, 'Visible', 'off');
            obj = obj.initTransaction();
            setappdata(obj.Figure.home,'obj',obj);
        end
        
    end
    
    
    
end