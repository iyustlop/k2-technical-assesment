package sop.scenario5.users;

import com.intuit.karate.junit5.Karate;

class UsersRunner {
    
    @Karate.Test
    Karate testUsers() {
        return Karate.run("nonExistingUsers").relativeTo(getClass());
    }    

}
