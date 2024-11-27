package com.lottery.repository;

import com.lottery.entity.DateDim;
import com.lottery.entity.ETLLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DateDimRepository extends JpaRepository<DateDim, Long> {
}
