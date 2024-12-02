package com.lottery.repository;

import com.lottery.entity.Config;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface ConfigRepository extends JpaRepository<Config, Long> {
    @Query("SELECT c FROM Config c WHERE c.id NOT IN (" +
            "SELECT l.config.id FROM Log l WHERE l.status = 'SUCCESS')" +
            " ORDER BY c.createAt ASC")
    List<Config> findUnfinishedConfigs();

    @Query("SELECT c FROM Config c WHERE c.createAt = :date AND c.id NOT IN (" +
            "SELECT l.config.id FROM Log l WHERE l.status = 'SUCCESS')" +
            " ORDER BY c.createAt ASC")
    List<Config> findUnfinishedConfigs(@Param("date") LocalDate date);
}
