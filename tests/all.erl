%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(all).      
    
 
-export([start/1

	]).

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

start([_ClusterSpec,_HostSpec])->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    
    ok=setup(),
    ok=test_1(),
    ok=test_2(),
    ok=test_3(),
   
    io:format("Stop OK !!! ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    io:format(" init stop ~p~n",[init:stop()]),
    timer:sleep(2000),

    ok.


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
test_1()->
  io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    AllNodes=test_nodes:get_nodes(),
    [N1,N2,N3,N4]=AllNodes,
    %% Init
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
      

    %% N1
    ok=rpc:call(N1,application,start,[db_test],5000),
    pong=rpc:call(N1,db_test,ping,[],5000),
    pong=rpc:call(N1,db,ping,[],5000),

    [N1]=lists:sort(rpc:call(N1,mnesia,system_info,[running_db_nodes],5000)),
    io:format("N1 dist OK! ~p~n",[{?MODULE,?LINE}]),
 %   yes=rpc:call(N1,mnesia,system_info,[],5000),
 
    %% N2
    ok=rpc:call(N2,application,start,[db_test],5000),
    pong=rpc:call(N2,db_test,ping,[],5000),
    pong=rpc:call(N2,db,ping,[],5000),
    [N1,N2]=lists:sort(rpc:call(N1,mnesia,system_info,[running_db_nodes],5000)),
    [N1,N2]=lists:sort(rpc:call(N2,mnesia,system_info,[running_db_nodes],5000)),
 %   yes=rpc:call(N2,mnesia,system_info,[],5000),
    io:format("N2 dist OK! ~p~n",[{?MODULE,?LINE}]),

  %% N3
    ok=rpc:call(N3,application,start,[db_test],5000),
    pong=rpc:call(N3,db_test,ping,[],5000),
    pong=rpc:call(N3,db,ping,[],5000),
  
    [N1,N2,N3]=lists:sort(rpc:call(N1,mnesia,system_info,[running_db_nodes],5000)),
    [N1,N2,N3]=lists:sort(rpc:call(N2,mnesia,system_info,[running_db_nodes],5000)),
    [N1,N2,N3]=lists:sort(rpc:call(N3,mnesia,system_info,[running_db_nodes],5000)),
 %   yes=rpc:call(N3,mnesia,system_info,[],5000),
    io:format("N3 dist OK! ~p~n",[{?MODULE,?LINE}]),
 %% N4
    ok=rpc:call(N4,application,start,[db_test],5000),
    pong=rpc:call(N4,db_test,ping,[],5000),
    pong=rpc:call(N4,db,ping,[],5000),
    [N1,N2,N3,N4]=lists:sort(rpc:call(N1,mnesia,system_info,[running_db_nodes],5000)),
    [N1,N2,N3,N4]=lists:sort(rpc:call(N2,mnesia,system_info,[running_db_nodes],5000)),
    [N1,N2,N3,N4]=lists:sort(rpc:call(N3,mnesia,system_info,[running_db_nodes],5000)),
    [N1,N2,N3,N4]=lists:sort(rpc:call(N4,mnesia,system_info,[running_db_nodes],5000)),
   
 %   yes=rpc:call(N4,mnesia,system_info,[],5000),
    io:format("N4 dist OK! ~p~n",[{?MODULE,?LINE}]),
    ok.

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
test_2()->
    AllNodes=test_nodes:get_nodes(),
    [N1,N2,N3,N4]=AllNodes,
    P1={joakim,leche,1962},
    P2={asa,leche,1966},
    P3={david,leche,1995},
    P4={erika,leche,1998},


    {atomic,ok}=rpc:call(N1,person,create,[joakim,leche,1962],5000),
    [P1]=lists:sort(rpc:call(N1,person,read_all,[],5000)),
    [P1]=lists:sort(rpc:call(N2,person,read_all,[],5000)),
    [P1]=lists:sort(rpc:call(N3,person,read_all,[],5000)),
    [P1]=lists:sort(rpc:call(N4,person,read_all,[],5000)),
    io:format("Create P1  OK! ~p~n",[{?MODULE,?LINE}]),

    {atomic,ok}=rpc:call(N2,person,create,[asa,leche,1966],5000),
    [P2,P1]=lists:sort(rpc:call(N1,person,read_all,[],5000)),
    io:format("Create P1,P2   OK! ~p~n",[{?MODULE,?LINE}]),
    {atomic,ok}=rpc:call(N3,person,create,[david,leche,1995],5000),
    {atomic,ok}=rpc:call(N4,person,create,[erika,leche,1998],5000),

    [P2,P3,P4,P1]=lists:sort(rpc:call(N1,person,read_all,[],5000)),
    [P2,P3,P4,P1]=lists:sort(rpc:call(N2,person,read_all,[],5000)),
    [P2,P3,P4,P1]=lists:sort(rpc:call(N3,person,read_all,[],5000)),
    [P2,P3,P4,P1]=lists:sort(rpc:call(N4,person,read_all,[],5000)),
    io:format("Create P1,P2, P3, P4   OK! ~p~n",[{?MODULE,?LINE}]),
    ok.
    
    
 %%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
test_3()->
    AllNodes=test_nodes:get_nodes(),
    [N1,N2,N3,N4]=AllNodes,
    P1={joakim,leche,1962},
    P2={asa,leche,1966},
    P3={david,leche,1995},
    P4={erika,leche,1998},

 %% kill N3

    io:format("kill N3  ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    rpc:call(N3,init,stop,[],5000),
    timer:sleep(1500),
 %   yes=rpc:call(N4,mnesia,system_info,[],5000),

    [P2,P3,P4,P1]=lists:sort(rpc:call(N1,person,read_all,[],5000)),
    [P2,P3,P4,P1]=lists:sort(rpc:call(N2,person,read_all,[],5000)),
    {badrpc,nodedown}=rpc:call(N3,person,read_all,[],5000),
    [P2,P3,P4,P1]=lists:sort(rpc:call(N4,person,read_all,[],5000)),
    io:format("Kill N3  OK! ~p~n",[{?MODULE,?LINE}]),

    {ok,N3}=test_nodes:start_slave("c3"),
    [rpc:call(N3,net_adm,ping,[N],5000)||N<-AllNodes],
    true=rpc:call(N3,code,add_patha,["ebin"],5000),    
    true=rpc:call(N3,code,add_patha,["tests_ebin"],5000),     
    true=rpc:call(N3,code,add_patha,["common/ebin"],5000),     
    ok=rpc:call(N3,application,start,[common],5000), 
    true=rpc:call(N3,code,add_patha,["sd/ebin"],5000),     
    ok=rpc:call(N3,application,start,[sd],5000), 
    ok=rpc:call(N3,application,start,[db_test],5000),
    pong=rpc:call(N3,db_test,ping,[],5000),
    pong=rpc:call(N3,db,ping,[],5000),

 %   yes=rpc:call(N4,mnesia,system_info,[],5000),
    
    [P2,P3,P4,P1]=lists:sort(rpc:call(N1,person,read_all,[],5000)),
    [P2,P3,P4,P1]=lists:sort(rpc:call(N2,person,read_all,[],5000)),
    [P2,P3,P4,P1]=lists:sort(rpc:call(N3,person,read_all,[],5000)),
    [P2,P3,P4,P1]=lists:sort(rpc:call(N4,person,read_all,[],5000)),
    io:format("Restart  N3  OK! ~p~n",[{?MODULE,?LINE}]),
    ok.


%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    ok=test_nodes:start_nodes(),
    [rpc:call(N,code,add_patha,["ebin"],5000)||N<-test_nodes:get_nodes()],    
    [rpc:call(N,code,add_patha,["tests_ebin"],5000)||N<-test_nodes:get_nodes()],     
    [rpc:call(N,code,add_patha,["common/ebin"],5000)||N<-test_nodes:get_nodes()],     
    [rpc:call(N,application,start,[common],5000)||N<-test_nodes:get_nodes()], 
    [rpc:call(N,code,add_patha,["sd/ebin"],5000)||N<-test_nodes:get_nodes()],     
    [rpc:call(N,application,start,[sd],5000)||N<-test_nodes:get_nodes()], 
    
    ok.
