"""
 ***************************************************************************

 DMS Container

 Copyright (c) 2016-2020 bit Time Professionals


 ***************************************************************************

 Licensed under the Commercial License
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License asking to the software provider

 Unless agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 *************************************************************************** }
"""
import logging
from eventstreamsproxy import EventStreamsRPCProxy, EventStreamsRPCException
# from dms.authproxy import AuthRPCProxy, AuthRPCException

username = "user_admin"
password = "pwd1"
base_url_auth = "https://localhost/authrpc"
base_url_email = "https://localhost/emailrpc"
base_url_eventstreams = "https://localhost/eventstreamsrpc"
headers = {"content-type": "application/json", "accept": "application/json"}


def get_eventstreams_proxy() -> EventStreamsRPCProxy:
    return EventStreamsRPCProxy(base_url_eventstreams)


# def get_auth_proxy() -> AuthRPCProxy:
#     return AuthRPCProxy(base_url_auth)
