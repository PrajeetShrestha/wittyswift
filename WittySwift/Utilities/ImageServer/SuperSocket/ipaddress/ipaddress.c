#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

void getIpAddress(char* ip)
{
    struct ifaddrs *ifaddr, *ifa;
    int family, s;
    char host[NI_MAXHOST];

    if (getifaddrs(&ifaddr) == -1)
    {
        perror("getifaddrs");
        exit(EXIT_FAILURE);
    }
    for (ifa = ifaddr; ifa != NULL; ifa = ifa->ifa_next)
    {
        if (ifa->ifa_addr == NULL)
            continue;

        s=getnameinfo(ifa->ifa_addr,sizeof(struct sockaddr_in),host, NI_MAXHOST, NULL, 0, NI_NUMERICHOST);

        if( /*(strcmp(ifa->ifa_name,"wlan0")==0)&&( */ ifa->ifa_addr->sa_family==AF_INET) // )
        {
            if (s != 0)
            {
                exit(0);
            }
            if(strcmp(ifa->ifa_name, "en0") == 0) {
                strcpy(ip, host);
            }
        }
    }
    freeifaddrs(ifaddr);
}
