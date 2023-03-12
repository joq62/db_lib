%-define(HostSpecDir,"host_specs").
%-define(GitPathHostSpecs,"https://github.com/joq62/host_specs.git").

-define(TABLE,person).
-define(RECORD,?TABLE).
-record(?RECORD,{
		 surname,
		 family_name,
		 year_of_birth
		}).
