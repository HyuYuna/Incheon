/**
 * Class Summary. <br>
 * DB Controller class.
 * @since 1.00
 * @version 1.00 - 2011. 01. 20
 * @author 정소선
 * @see
 */
package egovframework.db;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.util.CommDef;
import egovframework.util.CommonUtil;

@Service("dbSvc")
public class DbController
{
	public int PAGE_ROWCOUNT = CommDef.PAGE_ROWCOUNT;

	@Resource(name="dbDao")
	public DbDao m_dao;

	public DbDao getDao(){
		return m_dao;
	}

	@SuppressWarnings("rawtypes")
	public int dbInsert( Map reqMap, String strXPath )
	{
		return m_dao.insert( reqMap, strXPath );
	}

	@SuppressWarnings("rawtypes")
	public int dbInsert( List lst, String strXPath )
	{
		return m_dao.insert( lst, strXPath );
	}


	@SuppressWarnings("rawtypes")
	public int dbUpdate( Map reqMap, String strXPath )
	{
		return m_dao.update( reqMap, strXPath );
	}

	@SuppressWarnings("rawtypes")
	public int dbDelete( Map reqMap, String strXPath )
	{
		return m_dao.delete( reqMap, strXPath );
	}

	public int dbDelete(String strXPath )
	{
		return m_dao.delete(strXPath );
	}

	@SuppressWarnings("rawtypes")
	public List dbList(String strXPath )
	{
		return m_dao.list(strXPath);
	}

	@SuppressWarnings("rawtypes")
	public List dbList( Map reqMap, String strXPath )
	{
		return m_dao.list(reqMap, strXPath);
	}

	@SuppressWarnings("rawtypes")
	public List dbList( Map reqMap, String strXPath,   int iRowStartPos, int iCount)
	{
		return m_dao.list(reqMap, strXPath, iRowStartPos, iCount);
	}

	@SuppressWarnings("rawtypes")
	public List dbPagingList( Map reqMap, String strXPath,   int iRowStartPos, int iCount)
	{
		return m_dao.dbPagingList(reqMap, strXPath, iRowStartPos, iCount);
	}

	@SuppressWarnings("rawtypes")
	public Map dbDetail(String strXPath )
	{
		return m_dao.detail(strXPath);
	}

	@SuppressWarnings("rawtypes")
	public Map dbDetail( Map reqMap, String strXPath )
	{
		return m_dao.detail(reqMap, strXPath);
	}

	@SuppressWarnings("rawtypes")
	public int dbInt( Map reqMap, String strXPath)
	{
		return m_dao.getInt(reqMap, strXPath);
	}

	public int dbInt( String strXPath)
	{
		return m_dao.getInt(strXPath);
	}


	public long dbLong( String strXPath)
	{
		return m_dao.getLong(strXPath);
	}

	public int dbCount( String strXPath)
	{
		return m_dao.getCount(strXPath);
	}

	@SuppressWarnings("rawtypes")
	public int dbCount( Map reqMap, String strXPath)
	{
		return m_dao.getCount(reqMap, strXPath);
	}

    /**
     * Method Summary. <br>
     * 한 페이지당 표시할 건수 값을 조회한다. method.
     * @param HashMap reqMap 파라미터 객체
     * @param String strMapKey HashMap의 키
     * @return 한 페이지당 표시할 건수
     * @throws
     * @since 1.00
     * @see
     */
	@SuppressWarnings("rawtypes")
	public int getPageRowCount(Map reqMap, String strMapKey)
	{
		return getPageRowCount(reqMap, strMapKey, PAGE_ROWCOUNT);
	}

    /**
     * Method Summary. <br>
     * 한 페이지당 표시할 건수 값을 조회한다. method.
     * @param HashMap reqMap 파라미터 객체
     * @param String strMapKey HashMap의 키
     * @return int 한 페이지당 표시할 건수
     * @throws
     * @since 1.00
     * @see
     */
	@SuppressWarnings("rawtypes")
	public int getPageRowCount(Map reqMap, String strMapKey, int nRowCount)
	{

		if (reqMap == null || reqMap.isEmpty())
			return nRowCount;

		nRowCount = Integer.parseInt( CommonUtil.getNullTrans(reqMap.get( strMapKey), nRowCount));

		return nRowCount;
	}


    /**
     * Method Summary. <br>
     * 현재 페이지 값을 조회한다. method.
     * @param HashMap reqMap 파라미터 객체
     * @param String strMapKey HashMap의 키
     * @return 현재 페이지 값
     * @throws
     * @since 1.00
     * @see
     */
	@SuppressWarnings("rawtypes")
	public int getPageNow(Map reqMap, String strMapKey)
	{
		int nPage = 1;

		if (reqMap == null || reqMap.isEmpty())
			return nPage;

		nPage = Integer.parseInt( CommonUtil.getNullTrans(reqMap.get( strMapKey), 1));

		return nPage;
	}

}