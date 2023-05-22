# Good Night
let users track when they go to bed and when they wake up. 

## Requirement
- [make](https://www.gnu.org/software/make/#download)
- docker

## Getting started
Execute command ```make build``` in the terminal, it will build docker images ,initialize the project, and start the good night service in the docker.

There are other make commands. Most of them are aim to develop. You can use ```make help``` to see the all commands.

## API spec
### users api
- GET /users
  - request body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    |  -  |  -  | - |
  - resonse body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | id |  integer | user id |
    | name |  string | user name |

- POST /users
  - request body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | name |  string | user name |
  - resonse body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | id |  integer | user id |
    | name |  string | user name |

- POST /users/follow
  - request body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | user_id |  integer | user id |
    | following_user_id |  integer | current user wants to follow user's id |
  - resonse body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | follower |  object | follower data |
    | follower.user_id |  integer | the follower's user_id |
    | follower.following_user_id |  integer | the followed user's id |

- POST /users/unfollow
  - request body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | user_id |  integer | user id |
    | unfollow_user_id |  integer | current user wants to unfollow user's id |
  - resonse body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    |  -  |  -  | - |

### sleep api
- POST /sleep/clock_in
  - request body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | user_id |  integer | user id |
  - resonse body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | clock_in |  string | The user's clock in time. (go to sleep) |
- POST /sleep/clock_out
  - request body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | user |  integer | user id |
  - resonse body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | clock_in |  string | The user's clock in time. (go to sleep) |
    | clock_out |  string | The user's clock out time. (wake up) |
    | sleep_length |  string | The user's sleep length. Use ```HH:mm:ss``` to represent. |
- GET /sleep/clocked_in_times
  - request body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | user |  integer | user id |
  - resonse body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | user_id |  integer | user id |
    | sleep_records |  object[] | The users' all sleep records. |
    | sleep_records[].clock_in |  string | The user's clock in time. (go to sleep) |
    | sleep_records[].clock_out |  string | The user's clock out time. (wake up) |
    | sleep_records[].sleep_length |  string | The user's sleep length. Use ```HH:mm:ss``` to represent. |

- GET /sleep/following_user_records
  - request body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | user |  integer | user id |

  - resonse body

    |  Parameter   |  Type  | Description |
    |  ----  | ----  | ---- |
    | sleep_records |  object[] | Represent current users' friends' sleep records. (order by sleep length desc) |
    | sleep_records[].user_id |  integer | Following user id |
    | sleep_records[].name |  object[] | Following user name |
    | sleep_records[].clock_in |  string | Following user's clock in time. (go to sleep) |
    | sleep_records[].clock_out |  string | Following user's clock out time. (wake up) |
    | sleep_records[].sleep_length |  string | Following user's sleep length. Use ```HH:mm:ss``` to represent. |

### postman api collection
Here is the [postman collection](good-night.postman_collection.json) if needing to test. 