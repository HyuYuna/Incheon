/**
 * Class Summary. <br>
 * DBDAO class.
 * @since 1.00
 * @version 1.00 - 2011. 01. 20
 * @author 정소선
 * @see
 */
package egovframework.db;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Repository("dbDao")
public class DbDao extends EgovAbstractMapper
{
	private static final Logger LOGGER = LoggerFactory.getLogger(DbDao.class);

	@SuppressWarnings("rawtypes")
	public int insert( Map reqMap, String strXPath )
	{
		return insert( strXPath , reqMap );
	}

	@SuppressWarnings("rawtypes")
	public int insert( List lst, String strXPath )
	{
		SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(getSqlSession().getConfiguration());
		SqlSession sqlSessionBatch = sqlSessionFactory.openSession(ExecutorType.BATCH, false);

		int nSuccess = 0;

		try {

			for(int nLoop=0; nLoop < lst.size(); nLoop++)
			{
				Map reqMap = (Map)lst.get(nLoop);
			    nSuccess = sqlSessionBatch.insert( strXPath , reqMap );
			}
        } catch (RuntimeException e) {
		    LOGGER.error(e.getMessage());
		    sqlSessionBatch.rollback();
        } catch(Exception e) {
		    LOGGER.error(e.getMessage());
		    sqlSessionBatch.rollback();
        } finally {
			sqlSessionBatch.commit(true );
			sqlSessionBatch.close( );
		}
		return nSuccess;
	}

	@SuppressWarnings("rawtypes")
	public int update( Map reqMap, String strXPath )
	{
		return update(strXPath , reqMap );
	}

	@SuppressWarnings("rawtypes")
	public int delete( Map reqMap, String strXPath )
	{
		return delete(strXPath , reqMap );
	}


	public int delete( String strXPath)
	{
		return delete(strXPath );
	}

	@SuppressWarnings("rawtypes")
	public List list(String strXPath )
	{
		return selectList( strXPath);
	}

	@SuppressWarnings("rawtypes")
	public List list( Map reqMap, String strXPath )
	{
		return selectList(strXPath , reqMap );
	}

	@SuppressWarnings("rawtypes")
	public List list( Map reqMap, String strXPath,   int iRowStartPos, int iCount)
	{
		RowBounds rbs = new RowBounds(iRowStartPos, iCount);

		return selectList(strXPath , reqMap, rbs );
	}

	@SuppressWarnings( { "unchecked", "rawtypes" } )
	public List dbPagingList( Map reqMap, String strXPath,   int iRowStartPos, int iCount)
	{
		reqMap.put("page_start", (iRowStartPos + 1 ) ); // 시작위치
		reqMap.put("page_end",   (iRowStartPos + iCount)  ); // 종료위치

		return selectList(strXPath , reqMap );
	}

	@SuppressWarnings("rawtypes")
	public Map detail( Map reqMap, String strXPath )
	{
		return (Map)selectOne(strXPath , reqMap);
	}

	@SuppressWarnings("rawtypes")
	public Map detail( String strXPath)
	{
		return (Map)selectOne(strXPath);
	}

	@SuppressWarnings("rawtypes")
	public int getInt(Map reqMap, String strXPath)
	{
		int nCount = -999;
		nCount = (Integer)selectOne(strXPath, reqMap);

		return nCount;
	}
	public long getLong(String strXPath)
	{
		long nCount = -999;
		nCount = (Long)selectOne(strXPath);

		return nCount;
	}

	public int getInt(String strXPath)
	{
		int nCount = -999;
		nCount = (Integer)selectOne(strXPath);

		return nCount;
	}

	@SuppressWarnings("rawtypes")
	public int getCount(Map reqMap, String strXPath) {
		return getInt(reqMap, strXPath) ;
	}

	public int getCount(String strXPath) {
		return getInt(strXPath) ;
	}

}