package sop.scenario4.users;

import com.intuit.karate.junit5.Karate;

class UsersRunner {
    
    @Karate.Test
    Karate testUsers() {
        return Karate.run("usersPagination").relativeTo(getClass());
    }    

}
