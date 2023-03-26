catalunha@pop-os:~/myapp$ flutter create --project-name=cimat --org to.brintec --platforms android,web ./cimat
catalunha@pop-os:~/myapp/cimat/back4app$ ln -s /home/catalunha/myapp/cimat/build/web public

flutter build web && cd back4app/cimat/ && b4a deploy