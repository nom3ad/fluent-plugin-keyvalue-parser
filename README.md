#fluent-plugin-jsonify

[Fluent](http://www.fluentd.org/) parser plugin for key:value formatted logs.


##Installation

```shell
$ td-agent-gem install fluent-plugin-jsonify
```

##How to use

Edit `/etc/td-agent/td-agent.conf` file.

* with tail plugin
```conf
<source>
  type tail
  path /var/log/netscreen.log
  tag  netscreen_logs 
  pair_delimiter  ","
  key_value_seperator "="
  pos_file /var/run/td-agent/netscreen-log.pos
  format jsonify
</source>
```
* with parser plugin
```conf
<filter tag>
 type parser
 format jsonify
 pair_delimiter  ","
 key_value_seperator "="
 key_name keyToParse
</filter>
```
using above configuration,
```
key1=val1,key2=value2,"some key" = somevalue,diff_key="another value"
```
will be parsed as

```json
{"key1":"val1", "key2":"value2","some key":"somevalue","diff_key":"another value"}
```

####NOTE
* if the key is not in quotes and pair_delimiter occures in key,plugin will handle it.
  
  eg:
  
  In below log, *pair_delimiter = " "  (space)*  is occured in key 'src zone'. 
    
  `devname=FT6H duration=194 service=http proto=6 `**`src zone=Trust`**` port=40055 policy_id=194`
  
  will be parsed as 
  ```json
  {"devname":"FT6H", "duration":"194","service":"http","src zone":"Trust","policy_id":"194"}
  ```
* But if value is not quoted, you should use optional parameter *'adjustment_rules'* to correct the parsing.

## Option Parameters

- **pair_delimiter**
    
    delimiter which seperate each key-value pairs. can be multi-character.
    whitespaces or tabs can be given in quotes: ie, " " or "\t" .
    By default it is ",".     

- **key_value_seperator**

    A string or character that seprates key and its value.
    By default it is "="
- **adjustment_rules**

    Regular expression rules for some keys, repesented as json , to adjust parsed records accordingly.
    
    {key1:regex1,key2:regex2}
    
   eg:
   
   normally following logs,
   
  `devname=FT6H `**`service=http`**`proto=6 src zone=Trust dst zone=Untrust`
  
  `devname=FT6H `**`service=NETBIOS (NS)`**`proto=17 src zone=Trust dst zone=Untrust`
  
   will be parse as 
   
   ```json
   {"devname":"FT6H","service":"http","proto":"6","src zone":"Trust","dst zone":"Untrust"}
   
   {"devname":"FT6H","service":"NETBIOS","(NS) proto":"6","src zone":"Trust","dst zone":"Untrust"}
   ```   
   in second case where key *"service"* only received first part of its value, becouse value not quoted and delimiter(here space) occured in value. 
   
   Also next key *"proto"* is wrongly taken as *"(NS) proto"*.
   
   to overcome this problem we can use,
   
   `adjustment_rules {"service":"NETBIOS \\(.*\\)"}` in configuration.
   
   this will parse *service* key with value containing NETBIOS(NS) whenever it occures.
