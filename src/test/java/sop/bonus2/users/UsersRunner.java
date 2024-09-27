package sop.bonus2.users;

import com.intuit.karate.junit5.Karate;

class UsersRunner {
    
    @Karate.Test
    Karate testUsers() {
        return Karate.run("bonusUsers2").relativeTo(getClass());
    }    

}
